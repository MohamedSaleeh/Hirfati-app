import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../../../../notifications/presentation/providers/notifications_stream_provider.dart';
import '../providers/craftsmen_stream_provider.dart';
import '../providers/home_client_provider.dart';
import '../providers/search_craftsmen_provider.dart';
import '../widgets/categories_section.dart';
import '../widgets/craftsman_card_widget.dart';
import '../widgets/home_location_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/live_map_card.dart';
import '../widgets/recommended_section.dart';

class HomeScreenClient extends ConsumerStatefulWidget {
  const HomeScreenClient({super.key});

  @override
  ConsumerState<HomeScreenClient> createState() => _HomeScreenClientState();
}

class _HomeScreenClientState extends ConsumerState<HomeScreenClient> {
  final _searchControl = FormControl<String>(value: '');
  String _searchQuery = '';
  bool _showAllCategories = false;

  @override
  void initState() {
    super.initState();
    _searchControl.valueChanges.listen((value) {
      if (mounted) {
        setState(() => _searchQuery = value ?? '');
      }
    });
  }

  @override
  void dispose() {
    _searchControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final homeAsync = ref.watch(homeClientProvider);
    final nearbyAsync = ref.watch(craftsmenStreamProvider);
    final unreadCountStream = ref.watch(unreadNotificationsCountStreamProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: homeAsync.when(
        loading: () => Center(
          child: Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 150,
            height: 150,
            repeat: true,
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 12),
              Text(error.toString().i18n),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.refresh(homeClientProvider),
                child: Text('Retry'.i18n),
              ),
            ],
          ),
        ),
        data: (state) {
          final isSearching = _searchQuery.trim().isNotEmpty;
          final searchAsync = isSearching
              ? ref.watch(searchCraftsmenProvider(_searchQuery))
              : null;

          final craftsmenToShow = state.selectedCategoryId != null
              ? state.filteredCraftsmen
              : state.recommendedCraftsmen;

          return RefreshIndicator(
            onRefresh: () => ref.read(homeClientProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeLocationHeader(
                            city: state.userCity,
                            unreadCountStream: unreadCountStream,
                          ),
                          const SizedBox(height: 20),
                          HomeSearchBar(searchControl: _searchControl),
                          const SizedBox(height: 24),
                          CategoriesSection(
                            ref: ref,
                            categories: state.categories,
                            selectedCategoryId: state.selectedCategoryId,
                            showAll: _showAllCategories,
                            onSeeAll: () {
                              setState(() {
                                _showAllCategories = !_showAllCategories;
                              });
                            },
                            onCategoryTap: (category) {
                              ref
                                  .read(homeClientProvider.notifier)
                                  .selectCategory(category.id);
                            },
                          ),
                          const SizedBox(height: 20),
                          LiveMapCard(
                            nearbyCount: nearbyAsync.when(
                              data: (list) => list.length,
                              loading: () => 12,
                              error: (_, _) => 0,
                            ),
                            avatarUrls: nearbyAsync.when(
                              data: (list) =>
                                  list.take(3).map((c) => c.avatarUrl).toList(),
                              loading: () => [],
                              error: (_, _) => [],
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (isSearching)
                            _SearchResults(searchAsync: searchAsync!)
                          else
                            RecommendedSection(
                              craftsmen: craftsmenToShow,
                              selectedCategoryId: state.selectedCategoryId,
                            ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final AsyncValue<List> searchAsync;

  const _SearchResults({required this.searchAsync});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return searchAsync.when(
      loading: () => Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 150,
            height: 150,
            repeat: true,
          ),
        ),
      ),
      error: (e, _) => Center(
        child: Text(e.toString(), style: TextStyle(color: colorScheme.error)),
      ),
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No craftsmen found'.i18n,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${results.length} result${results.length == 1 ? '' : 's'}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  CraftsmanCardWidget(craftsman: results[index] as dynamic),
            ),
          ],
        );
      },
    );
  }
}
