import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Home_client/domain_models/category_model.dart';
import '../../data/repositories/create_order_repository_impl.dart';
import '../../domain/models/create_order_model.dart';
import '../../domain/models/order_photo_model.dart';
import '../../domain/models/service_model.dart';
import '../../domain/repositories/create_order_repository.dart';

class CreateOrderState {
  final int currentStep;
  final bool isLoadingCategories;
  final bool isSubmitting;
  final String? errorMessage;
  final List<CategoryModel> categories;
  final List<ServiceModel> workerServices;
  final String? selectedServiceId;
  final bool isDirectBooking;
  final CreateOrderModel order;
  final bool lockCategory;

  const CreateOrderState({
    this.currentStep = 0,
    this.isLoadingCategories = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.categories = const [],
    this.workerServices = const [],
    this.selectedServiceId,
    this.isDirectBooking = false,
    this.order = const CreateOrderModel(),
    this.lockCategory = false,
  });

  CreateOrderState copyWith({
    int? currentStep,
    bool? isLoadingCategories,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    List<CategoryModel>? categories,
    List<ServiceModel>? workerServices,
    String? selectedServiceId,
    bool? isDirectBooking,
    CreateOrderModel? order,
    bool? lockCategory,
  }) {
    return CreateOrderState(
      currentStep: currentStep ?? this.currentStep,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      categories: categories ?? this.categories,
      workerServices: workerServices ?? this.workerServices,
      selectedServiceId: selectedServiceId ?? this.selectedServiceId,
      isDirectBooking: isDirectBooking ?? this.isDirectBooking,
      order: order ?? this.order,
      lockCategory: lockCategory ?? this.lockCategory,
    );
  }
}

final createOrderProvider =
    StateNotifierProvider<CreateOrderNotifier, CreateOrderState>((ref) {
      return CreateOrderNotifier(ref.read(createOrderRepositoryProvider));
    });

class CreateOrderNotifier extends StateNotifier<CreateOrderState> {
  static const _draftKey = 'create_order_draft_v1';
  final CreateOrderRepository _repo;

  CreateOrderNotifier(this._repo) : super(const CreateOrderState()) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([
      loadCategories(),
      _loadDraft(),
      _loadDefaultAddressIfNeeded(),
    ]);
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoadingCategories: true, clearError: true);
    try {
      final categories = await _repo.getCategories();
      state = state.copyWith(
        isLoadingCategories: false,
        categories: categories,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingCategories: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _loadDefaultAddressIfNeeded() async {
    if (state.order.address != null &&
        state.order.latitude != null &&
        state.order.longitude != null) {
      return;
    }
    try {
      final address = await _repo.getDefaultAddress();
      if (address.address == null) return;
      state = state.copyWith(
        order: state.order.copyWith(
          address: address.address,
          latitude: address.latitude,
          longitude: address.longitude,
        ),
      );
      await _persistDraft();
    } catch (_) {}
  }

  void nextStep() {
    if (!validateStep(state.currentStep)) return;
    if (state.currentStep >= 3) return;
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep <= 0) return;
    state = state.copyWith(currentStep: state.currentStep - 1);
  }

  void setCategory(String id, String name) {
    if (state.lockCategory) return;
    state = state.copyWith(
      order: state.order.copyWith(categoryId: id, categoryName: name),
      clearError: true,
    );
    _persistDraft();
  }

  // 🆕 اختيار خدمة من خدمات الحرفي
  void selectService(ServiceModel service) {
    state = state.copyWith(
      selectedServiceId: service.id,
      order: state.order.copyWith(
        serviceId: service.id,
        serviceTitle: service.title,
        servicePrice: service.price,
        serviceDurationMinutes: service.durationMinutes,
        estimatedPrice: service.price,
        categoryName: service.title, // للعرض
      ),
      clearError: true,
    );
    _persistDraft();
  }

  // 🆕 ربط الحجز المباشر بحرفي معين
  void bindBookingContext({
    required String workerId,
    required String serviceId,
    required String serviceName,
    required double estimatedPrice,
  }) async {
    if (workerId.isEmpty) return;

    // تعيين الحالة كحجز مباشر
    state = state.copyWith(
      isDirectBooking: true,
      lockCategory: true, // منع اختيار فئة
      clearError: true,
      order: state.order.copyWith(
        workerId: workerId,
        serviceId: serviceId,
        estimatedPrice: estimatedPrice > 0
            ? estimatedPrice
            : state.order.estimatedPrice,
      ),
    );

    try {
      // جلب جميع خدمات الحرفي
      final services = await _repo.getWorkerServices(workerId);
      if (services.isNotEmpty) {
        state = state.copyWith(workerServices: services);

        // إذا كانت الخدمة المحددة موجودة ضمن القائمة، اخترها
        final matched = services.firstWhere(
          (s) => s.id == serviceId,
          orElse: () => services.first,
        );
        selectService(matched);
      } else {
        // لا توجد خدمات مسجلة للحرفي، نعتمد على الوصف
        state = state.copyWith(
          errorMessage:
              'This craftsman has no predefined services. Please describe your need.',
        );
      }
    } catch (e) {
      // فشل جلب الخدمات
      state = state.copyWith(errorMessage: 'Could not load services: $e');
    }
    _persistDraft();
  }

  void setDescription(String text) {
    state = state.copyWith(
      order: state.order.copyWith(description: text),
      clearError: true,
    );
    _persistDraft();
  }

  Future<void> addPhoto(String localPath) async {
    final current = state.order.photos;
    if (current.length >= 4) {
      state = state.copyWith(errorMessage: 'Maximum 4 photos allowed');
      return;
    }

    if (kIsWeb) {
      final model = OrderPhotoModel(
        localPath: localPath,
        fileName: _extractFileNameFromBlobUrl(localPath),
        fileSize: null,
      );
      state = state.copyWith(
        order: state.order.copyWith(photos: [...current, model]),
        clearError: true,
      );
      await _persistDraft();
      return;
    }

    try {
      final file = File(localPath);
      final exists = await file.exists();
      if (!exists) {
        state = state.copyWith(errorMessage: 'File does not exist');
        return;
      }
      final stat = await file.stat();
      final model = OrderPhotoModel(
        localPath: localPath,
        fileName: file.uri.pathSegments.isNotEmpty
            ? file.uri.pathSegments.last
            : null,
        fileSize: stat.size,
      );
      state = state.copyWith(
        order: state.order.copyWith(photos: [...current, model]),
        clearError: true,
      );
      await _persistDraft();
    } catch (e) {
      print('❌ Error adding photo: $e');
      state = state.copyWith(errorMessage: 'Error adding photo: $e');
    }
  }

  String _extractFileNameFromBlobUrl(String blobUrl) {
    return 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  void removePhoto(int index) {
    final updated = [...state.order.photos]..removeAt(index);
    state = state.copyWith(order: state.order.copyWith(photos: updated));
    _persistDraft();
  }

  void setLocation(String address, double lat, double lng) {
    state = state.copyWith(
      order: state.order.copyWith(
        address: address,
        latitude: lat,
        longitude: lng,
      ),
      clearError: true,
    );
    _persistDraft();
  }

  void setSchedule(DateTime date, TimeOfDay time) {
    state = state.copyWith(
      order: state.order.copyWith(scheduledDate: date, scheduledTime: time),
      clearError: true,
    );
    _persistDraft();
  }

  void setTimeSlot(String slot) {
    state = state.copyWith(
      order: state.order.copyWith(preferredTimeSlot: slot),
      clearError: true,
    );
    _persistDraft();
  }

  void setAccessInstructions(String instructions) {
    state = state.copyWith(
      order: state.order.copyWith(accessInstructions: instructions),
      clearError: true,
    );
    _persistDraft();
  }

  bool validateStep(int step) {
    final order = state.order;
    switch (step) {
      case 0:
        if (state.isDirectBooking) {
          // الحجز المباشر: يجب اختيار خدمة، والوصف اختياري
          final serviceValid = state.selectedServiceId != null;
          print('🔍 Step 0 (direct booking): serviceValid=$serviceValid');
          return serviceValid;
        } else {
          // الحجز العادي: فئة محددة ووصف طويل بما يكفي
          final categoryValid = order.categoryId.isNotEmpty;
          final descValid = order.description.trim().length >= 20;
          print(
            '🔍 Step 0 (normal): categoryValid=$categoryValid, descValid=$descValid',
          );
          return categoryValid && descValid;
        }

      case 1:
        final valid = order.photos.isNotEmpty && order.photos.length <= 4;
        print(
          '🔍 Step 1 validation: $valid (photos count: ${order.photos.length})',
        );
        return valid;

      case 2:
        final valid =
            order.address != null &&
            order.address!.trim().isNotEmpty &&
            order.scheduledDate != null &&
            order.scheduledTime != null;
        print('🔍 Step 2 validation: $valid');
        return valid;

      case 3:
        final step0 = validateStep(0);
        final step1 = validateStep(1);
        final step2 = validateStep(2);
        final hasWorker = order.workerId != null && order.workerId!.isNotEmpty;
        final hasService =
            order.serviceId != null && order.serviceId!.isNotEmpty;
        print(
          '🔍 Step 3: step0=$step0, step1=$step1, step2=$step2, worker=$hasWorker, service=$hasService',
        );
        return step0 && step1 && step2 && hasWorker && hasService;

      default:
        return false;
    }
  }

  Future<bool> submitOrder() async {
    if (!validateStep(3)) {
      state = state.copyWith(
        errorMessage: 'Please complete all required fields',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      var photos = [...state.order.photos];

      for (int i = 0; i < photos.length; i++) {
        final localPath = photos[i].localPath;
        if (localPath == null || localPath.isEmpty) continue;
        photos[i] = photos[i].copyWith(isUploading: true);
        state = state.copyWith(order: state.order.copyWith(photos: photos));
        try {
          final remoteUrl = await _repo.uploadPhoto(localPath, orderId, i);
          photos[i] = photos[i].copyWith(
            isUploading: false,
            isUploaded: true,
            remoteUrl: remoteUrl,
          );
          state = state.copyWith(order: state.order.copyWith(photos: photos));
        } catch (e) {
          rethrow;
        }
      }

      final finalOrder = state.order.copyWith(
        photos: photos,
        price: state.order.servicePrice ?? state.order.estimatedPrice,
      );

      await _repo.createOrder(finalOrder);
      state = const CreateOrderState(order: CreateOrderModel());
      await _clearDraft();
      return true;
    } catch (e, stack) {
      print('❌ Submit order error: $e');
      print(stack);
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> _persistDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      'currentStep': state.currentStep,
      'isDirectBooking': state.isDirectBooking,
      'selectedServiceId': state.selectedServiceId,
      'workerId': state.order.workerId,
      'serviceId': state.order.serviceId,
      'serviceTitle': state.order.serviceTitle,
      'servicePrice': state.order.servicePrice,
      'categoryId': state.order.categoryId,
      'categoryName': state.order.categoryName,
      'description': state.order.description,
      'address': state.order.address,
      'latitude': state.order.latitude,
      'longitude': state.order.longitude,
      'scheduledDate': state.order.scheduledDate?.toIso8601String(),
      'scheduledHour': state.order.scheduledTime?.hour,
      'scheduledMinute': state.order.scheduledTime?.minute,
      'preferredTimeSlot': state.order.preferredTimeSlot,
      'accessInstructions': state.order.accessInstructions,
      'estimatedPrice': state.order.estimatedPrice,
      'photos': state.order.photos
          .map(
            (p) => {
              'localPath': p.localPath,
              'remoteUrl': p.remoteUrl,
              'isUploaded': p.isUploaded,
              'isUploading': p.isUploading,
              'fileName': p.fileName,
              'fileSize': p.fileSize,
            },
          )
          .toList(),
    };
    await prefs.setString(_draftKey, jsonEncode(payload));
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final photos = ((map['photos'] as List?) ?? [])
          .map(
            (e) => OrderPhotoModel(
              localPath: e['localPath'] as String?,
              remoteUrl: e['remoteUrl'] as String?,
              isUploaded: e['isUploaded'] == true,
              isUploading: false,
              fileName: e['fileName'] as String?,
              fileSize: e['fileSize'] as int?,
            ),
          )
          .toList();

      final hour = map['scheduledHour'] as int?;
      final minute = map['scheduledMinute'] as int?;

      state = state.copyWith(
        currentStep: (map['currentStep'] as int?) ?? 0,
        isDirectBooking: map['isDirectBooking'] == true,
        selectedServiceId: map['selectedServiceId'] as String?,
        lockCategory: (map['workerId'] as String?)?.isNotEmpty == true,
        order: state.order.copyWith(
          workerId: map['workerId'] as String?,
          serviceId: map['serviceId'] as String?,
          serviceTitle: map['serviceTitle'] as String?,
          servicePrice: (map['servicePrice'] as num?)?.toDouble(),
          categoryId: (map['categoryId'] as String?) ?? '',
          categoryName: (map['categoryName'] as String?) ?? '',
          description: (map['description'] as String?) ?? '',
          address: map['address'] as String?,
          latitude: (map['latitude'] as num?)?.toDouble(),
          longitude: (map['longitude'] as num?)?.toDouble(),
          scheduledDate: map['scheduledDate'] == null
              ? null
              : DateTime.tryParse(map['scheduledDate'] as String),
          scheduledTime: (hour != null && minute != null)
              ? TimeOfDay(hour: hour, minute: minute)
              : null,
          preferredTimeSlot: (map['preferredTimeSlot'] as String?) ?? 'morning',
          accessInstructions: (map['accessInstructions'] as String?) ?? '',
          estimatedPrice: (map['estimatedPrice'] as num?)?.toDouble() ?? 0,
          photos: photos,
        ),
      );
    } catch (_) {
      await _clearDraft();
    }
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }
}
