import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/home_client_repo_provider.dart';
import '../../domain_models/category_model.dart';
import '../../domain_models/craftsman_model.dart';
import '../../domain_models/home_client_state.dart';

final homeClientProvider =
    AsyncNotifierProvider<HomeClientNotifier, HomeClientState>(
      HomeClientNotifier.new,
    );

class HomeClientNotifier extends AsyncNotifier<HomeClientState> {
  @override
  Future<HomeClientState> build() async {
    return _load();
  }

  Future<void> refresh() async {
    final selectedCategoryId = state is AsyncData<HomeClientState>
        ? (state as AsyncData<HomeClientState>).value.selectedCategoryId
        : null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _load(selectedCategoryId: selectedCategoryId),
    );
  }

  Future<void> selectCategory(String? categoryId) async {
    if (state is AsyncData) {
      final currentState = (state as AsyncData<HomeClientState>).value;

      if (categoryId == null || categoryId == currentState.selectedCategoryId) {
        state = AsyncData(
          currentState.copyWith(
            selectedCategoryId: null,
            filteredCraftsmen: currentState.recommendedCraftsmen,
          ),
        );
        return;
      }

      final filtered = currentState.recommendedCraftsmen.where((craftsman) {
        return craftsman.categoryId == categoryId;
      }).toList();

      state = AsyncData(
        currentState.copyWith(
          selectedCategoryId: categoryId,
          filteredCraftsmen: filtered,
        ),
      );
    }
  }

  Future<HomeClientState> _load({String? selectedCategoryId}) async {
    final repo = ref.read(homeClientRepositoryProvider);

    final results = await Future.wait([
      repo.getCategories(),
      repo.getRecommendedCraftsmen(),
      repo.getUserCity(),
    ]);

    final categories = results[0] as List<CategoryModel>;
    final craftsmen = results[1] as List<CraftsmanModel>;
    final userCity = results[2] as String?;
    final filteredCraftsmen = selectedCategoryId == null
        ? craftsmen
        : craftsmen
              .where((craftsman) => craftsman.categoryId == selectedCategoryId)
              .toList();

    return HomeClientState(
      categories: categories,
      recommendedCraftsmen: craftsmen,
      filteredCraftsmen: filteredCraftsmen,
      selectedCategoryId: selectedCategoryId,
      userCity: userCity,
    );
  }
}
