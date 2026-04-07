import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/verification_request_model.dart';

class IdentityVerificationSupabaseDatasource {
  final SupabaseClient _client;

  IdentityVerificationSupabaseDatasource(this._client);

  Future<VerificationRequestModel?> getVerificationRequest(String userId) async {
    final response = await _client
        .from('verification_requests')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;

    return VerificationRequestModel(
      id: response['id'],
      userId: response['user_id'],
      fullName: response['full_name'],
      age: response['age'],
      email: response['email'],
      nationalIdUrl: response['national_id_url'],
      passportUrl: response['passport_url'],
      driversLicenseUrl: response['drivers_license_url'],
      selfieUrl: response['selfie_url'],
      status: _parseStatus(response['status']),
      rejectionReason: response['rejection_reason'],
      createdAt: response['created_at'] != null
          ? DateTime.parse(response['created_at'])
          : null,
      updatedAt: response['updated_at'] != null
          ? DateTime.parse(response['updated_at'])
          : null,
    );
  }

   Future<String?> uploadDocument(String userId, String documentType, String imagePath) async {
    final fileName = 'verification/${userId}_${documentType}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      if (kIsWeb) {
        final response = await http.get(Uri.parse(imagePath));
        if (response.statusCode != 200) {
          print('Failed to fetch image: ${response.statusCode}');
          return null;
        }
        final bytes = response.bodyBytes;
        await _client.storage.from('verification_docs').uploadBinary(fileName, bytes);
      } else {
        final file = File(imagePath);
        if (!await file.exists()) {
          print('File does not exist: $imagePath');
          return null;
        }
        await _client.storage.from('verification_docs').upload(fileName, file);
      }
      
      return _client.storage.from('verification_docs').getPublicUrl(fileName);
    } catch (e) {
      print('Error uploading document: $e');
      return null;
    }
  }

  Future<VerificationRequestModel> submitVerificationRequest({
    required String userId,
    required String fullName,
    required int age,
    required String email,
    String? nationalIdUrl,
    String? passportUrl,
    String? driversLicenseUrl,
    String? selfieUrl,
  }) async {
    final response = await _client
        .from('verification_requests')
        .insert({
          'user_id': userId,
          'full_name': fullName,
          'age': age,
          'email': email,
          'national_id_url': nationalIdUrl,
          'passport_url': passportUrl,
          'drivers_license_url': driversLicenseUrl,
          'selfie_url': selfieUrl,
          'status': 'pending',
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return VerificationRequestModel(
      id: response['id'],
      userId: response['user_id'],
      fullName: response['full_name'],
      age: response['age'],
      email: response['email'],
      nationalIdUrl: response['national_id_url'],
      passportUrl: response['passport_url'],
      driversLicenseUrl: response['drivers_license_url'],
      selfieUrl: response['selfie_url'],
      status: VerificationStatus.pending,
      rejectionReason: null,
      createdAt: DateTime.parse(response['created_at']),
      updatedAt: null,
    );
  }

  Future<String?> getVerificationStatus(String userId) async {
    final response = await _client
        .from('verification_requests')
        .select('status')
        .eq('user_id', userId)
        .maybeSingle();

    return response?['status'] as String?;
  }

  VerificationStatus _parseStatus(String? status) {
    switch (status) {
      case 'approved':
        return VerificationStatus.approved;
      case 'rejected':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.pending;
    }
  }
}