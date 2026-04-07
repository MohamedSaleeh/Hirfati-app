import '../../domain/models/address_model.dart';
import '../../domain/repositories/addresses_repository.dart';
import '../datasources/addresses_supabase_datasource.dart';

class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesSupabaseDatasource _datasource;

  AddressesRepositoryImpl(this._datasource);

  @override
  Future<List<AddressModel>> getAddresses(String userId) async {
    return await _datasource.getAddresses(userId);
  }

  @override
  Future<AddressModel> addAddress(String userId, AddressModel address) async {
    final newAddress = address.copyWith(
      id: '', // سيتم تجاهله في Supabase
      userId: userId,
    );
    return await _datasource.addAddress(userId, newAddress);
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    return await _datasource.updateAddress(address);
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    await _datasource.deleteAddress(addressId);
  }

  @override
  Future<void> setDefaultAddress(String userId, String addressId) async {
    await _datasource.setDefaultAddress(userId, addressId);
  }
}
