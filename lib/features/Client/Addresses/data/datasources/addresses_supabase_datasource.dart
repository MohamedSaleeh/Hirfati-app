import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/address_model.dart';

class AddressesSupabaseDatasource {
  final SupabaseClient _client;

  AddressesSupabaseDatasource(this._client);

  Future<List<AddressModel>> getAddresses(String userId) async {
    final response = await _client
        .from('addresses')
        .select()
        .eq('user_id', userId)
        .order('is_default', ascending: false)
        .order('created_at', ascending: true);

    return (response as List)
        .map((json) => AddressModel.fromJson(json))
        .toList();
  }

  Future<AddressModel> addAddress(String userId, AddressModel address) async {
    final data = {
    'user_id': userId,
    'label': address.label,
    'type': address.addressType.name,
    'full_address': address.fullAddress,
    'street': address.street,
    'city': address.city,
    'latitude': address.latitude,
    'longitude': address.longitude,
    'is_default': address.isDefault,
    'created_at': DateTime.now().toIso8601String(),
  };

    final response = await _client
        .from('addresses')
        .insert(data)
        .select()
        .single();

    return AddressModel.fromJson(response);
  }

  Future<AddressModel> updateAddress(AddressModel address) async {
     if (address.id == null) {
    throw Exception('Address ID is required for update');
  }
  
  final data = {
    'label': address.label,
    'type': address.addressType.name,
    'full_address': address.fullAddress,
    'street': address.street,
    'city': address.city,
    'latitude': address.latitude,
    'longitude': address.longitude,
    'is_default': address.isDefault,
    'updated_at': DateTime.now().toIso8601String(),
  };
  
  final response = await _client
      .from('addresses')
      .update(data)
      .eq('id', address.id as String)
      .select()
      .single();

  return AddressModel.fromJson(response);
  }

  Future<void> deleteAddress(String addressId) async {
    await _client
        .from('addresses')
        .delete()
        .eq('id', addressId);
  }

  Future<void> setDefaultAddress(String userId, String addressId) async {
    // إزالة الـ default من جميع العناوين
    await _client
        .from('addresses')
        .update({'is_default': false})
        .eq('user_id', userId);

    // تعيين الـ default للعنوان المحدد
    await _client
        .from('addresses')
        .update({'is_default': true})
        .eq('id', addressId);
  }
}