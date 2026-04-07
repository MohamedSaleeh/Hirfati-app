// lib/features/home_client/domain_models/home_client_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'category_model.dart';
import 'craftsman_model.dart';

part 'home_client_state.freezed.dart';

@freezed
abstract class HomeClientState with _$HomeClientState {
  const factory HomeClientState({
    @Default(false) bool isLoading,
    @Default([]) List<CategoryModel> categories,
    @Default([]) List<CraftsmanModel> recommendedCraftsmen,
    @Default([]) List<CraftsmanModel> filteredCraftsmen, 
    @Default('') String searchQuery,
    String? selectedCategoryId,
    String? errorMessage,
    String? userCity,
  }) = _HomeClientState;
}