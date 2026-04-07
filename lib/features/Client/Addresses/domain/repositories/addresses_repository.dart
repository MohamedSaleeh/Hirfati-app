import '../models/address_model.dart';

abstract class AddressesRepository {
  Future<List<AddressModel>> getAddresses(String userId);
  Future<AddressModel> addAddress(String userId, AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String userId, String addressId);
}