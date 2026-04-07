// lib/features/client_profile/presentation/providers/addresses_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/providers/addresses_providers.dart';
import '../../domain/models/address_model.dart';
import '../../domain/repositories/addresses_repository.dart';

class AddressesNotifier extends StateNotifier<AsyncValue<List<AddressModel>>> {
  final AddressesRepository _repository;
  final String _userId;

  AddressesNotifier(this._repository, this._userId)
    : super(const AsyncLoading());

  Future<void> loadAddresses() async {
    state = const AsyncLoading();
    try {
      final addresses = await _repository.getAddresses(_userId);
      state = AsyncData(addresses);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addAddress(AddressModel address) async {
    state.whenData((currentAddresses) async {
      try {
        state = const AsyncLoading();
        final newAddress = await _repository.addAddress(_userId, address);
        state = AsyncData([...currentAddresses, newAddress]);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> updateAddress(AddressModel address) async {
    state.whenData((currentAddresses) async {
      try {
        state = const AsyncLoading();
        final updatedAddress = await _repository.updateAddress(address);
        final updatedList = currentAddresses
            .map((a) => a.id == updatedAddress.id ? updatedAddress : a)
            .toList();
        state = AsyncData(updatedList);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> deleteAddress(String addressId) async {
    state.whenData((currentAddresses) async {
      try {
        state = const AsyncLoading();
        await _repository.deleteAddress(addressId);
        final updatedList = currentAddresses
            .where((a) => a.id != addressId)
            .toList();
        state = AsyncData(updatedList);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> setDefaultAddress(String addressId) async {
    state.whenData((currentAddresses) async {
      try {
        state = const AsyncLoading();
        await _repository.setDefaultAddress(_userId, addressId);

        final updatedList = currentAddresses.map((address) {
          return address.copyWith(isDefault: address.id == addressId);
        }).toList();

        state = AsyncData(updatedList);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }
}

final addressesProvider =
    StateNotifierProvider<AddressesNotifier, AsyncValue<List<AddressModel>>>((
      ref,
    ) {
      final repository = ref.watch(addressesRepositoryProvider);
      final user = ref.watch(supabaseClientProvider).auth.currentUser;

      if (user == null) throw Exception('User not authenticated');

      final notifier = AddressesNotifier(repository, user.id);
      notifier.loadAddresses();
      return notifier;
    });
