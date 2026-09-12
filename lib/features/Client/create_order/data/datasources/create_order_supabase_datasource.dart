import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Home_client/domain_models/category_model.dart';
import '../../domain/models/create_order_model.dart';
import '../../domain/models/service_model.dart';

class CreateOrderSupabaseDatasource {
  final SupabaseClient _client;

  CreateOrderSupabaseDatasource(this._client);

  Future<List<CategoryModel>> getCategories() async {
    final response = await _client
        .from('categories')
        .select('id, name, icon')
        .order('name');

    return (response as List<dynamic>)
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<ServiceModel>> getWorkerServices(String workerId) async {
    final response = await _client
        .from('services')
        .select('''
        id,
        title,
        description,
        price,
        duration_minutes,
        category_id,
        service_translations (
          locale,
          title,
          description
        )
      ''')
        .eq('worker_id', workerId)
        .order('created_at', ascending: true);
    debugPrint('SERVICES RESPONSE: $response');
    return (response as List<dynamic>).map((e) {
      final row = Map<String, dynamic>.from(e as Map);

      final rawTranslations = row['service_translations'] as List? ?? const [];

      final translations = rawTranslations
          .whereType<Map>()
          .map(
            (item) => ServiceTranslationModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      debugPrint(
        'SERVICE ${row['title']} -> '
        '${translations.map((t) => '${t.locale}:${t.title}').toList()}',
      );

      return ServiceModel(
        id: row['id'].toString(),
        title: row['title']?.toString() ?? 'Service',
        description: row['description']?.toString(),
        price: (row['price'] as num?)?.toDouble() ?? 0,
        durationMinutes: row['duration_minutes'] as int?,
        categoryId: row['category_id']?.toString(),
        translations: translations,
      );
    }).toList();
  }

  Future<String> uploadPhoto(
    String localPath,
    String orderId,
    int index,
  ) async {
    print('🔵 [Datasource] Uploading photo: $localPath');

    final fileName = 'orders/$orderId/photo_$index.jpg';

    if (kIsWeb) {
      // ✅ على الويب - localPath هو blob URL
      return await _uploadWebPhoto(localPath, fileName);
    } else {
      // ✅ على الموبايل - localPath هو مسار ملف
      return await _uploadMobilePhoto(localPath, fileName);
    }
  }

  // معالجة رفع الصور على الويب
  Future<String> _uploadWebPhoto(String blobUrl, String fileName) async {
    print('🔵 [Web] Uploading from blob URL: $blobUrl');

    try {
      // جلب البيانات من blob URL
      final response = await http.get(Uri.parse(blobUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch blob data: ${response.statusCode}');
      }

      final bytes = response.bodyBytes;
      print('📊 [Web] Fetched ${bytes.length} bytes');

      // رفع إلى Supabase Storage
      await _client.storage
          .from('order-photos')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // الحصول على الرابط العام
      final publicUrl = _client.storage
          .from('order-photos')
          .getPublicUrl(fileName);
      print('✅ [Web] Uploaded successfully: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('❌ [Web] Upload failed: $e');
      rethrow;
    }
  }

  // معالجة رفع الصور على الموبايل
  Future<String> _uploadMobilePhoto(String filePath, String fileName) async {
    print('🔵 [Mobile] Uploading from file: $filePath');

    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File does not exist: $filePath');
    }

    await _client.storage
        .from('order-photos')
        .upload(
          fileName,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    final publicUrl = _client.storage
        .from('order-photos')
        .getPublicUrl(fileName);
    print('✅ [Mobile] Uploaded successfully: $publicUrl');

    return publicUrl;
  }

  Future<void> createOrder(CreateOrderModel order) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    if (order.serviceId == null || order.serviceId!.isEmpty) {
      throw Exception('Service ID is required');
    }

    if (order.scheduledDate == null || order.scheduledTime == null) {
      throw Exception('Schedule is required');
    }

    final combined = DateTime(
      order.scheduledDate!.year,
      order.scheduledDate!.month,
      order.scheduledDate!.day,
      order.scheduledTime!.hour,
      order.scheduledTime!.minute,
    );

    // ✅ استخدام السعر من order أو estimatedPrice
    double finalPrice = order.price;
    if (finalPrice <= 0) {
      finalPrice = order.estimatedPrice;
    }

    if (finalPrice <= 0 && order.serviceId != null) {
      try {
        final service = await _client
            .from('services')
            .select('price')
            .eq('id', order.serviceId!)
            .maybeSingle();

        if (service != null) {
          finalPrice = (service['price'] as num?)?.toDouble() ?? 0;
          print('💰 Price fetched from service: $finalPrice');
        }
      } catch (e) {
        print('⚠️ Could not fetch service price: $e');
      }
    }

    print('💰 Final price for order: $finalPrice');

    await _client.from('orders').insert({
      'client_id': userId,
      'worker_id': order.workerId,
      'service_id': order.serviceId,
      'description': order.description,
      'price': finalPrice, // ✅ إضافة السعر
      'title': order.categoryName, // ✅ استخدام categoryName كعنوان
      'photos': order.photos
          .map((e) => e.remoteUrl)
          .whereType<String>()
          .toList(growable: false),
      'address': order.address,
      'latitude': order.latitude,
      'longitude': order.longitude,
      'scheduled_at': combined.toIso8601String(),
      'preferred_time_slot': order.preferredTimeSlot,
      'access_instructions': order.accessInstructions.isEmpty
          ? null
          : order.accessInstructions,
      'status': 'pending',
      'payment_status': 'pending',
      'created_by': 'client',
    });
  }

  Future<({String? address, double? latitude, double? longitude})>
  getDefaultAddress() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return (address: null, latitude: null, longitude: null);
    }

    final profile = await _client
        .from('profiles')
        .select('city, latitude, longitude')
        .eq('id', userId)
        .maybeSingle();

    if (profile == null) {
      return (address: null, latitude: null, longitude: null);
    }

    return (
      address: profile['city']?.toString(),
      latitude: (profile['latitude'] as num?)?.toDouble(),
      longitude: (profile['longitude'] as num?)?.toDouble(),
    );
  }
}
