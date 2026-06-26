import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../../translations.dart';
import '../../domain/models/work_item_model.dart';
import '../providers/work_gallery_provider.dart';
import '../widgets/work_item_card.dart';
import '../widgets/category_filter_chips.dart';

class WorkGalleryScreen extends ConsumerStatefulWidget {
  const WorkGalleryScreen({super.key});

  @override
  ConsumerState<WorkGalleryScreen> createState() => _WorkGalleryScreenState();
}

class _WorkGalleryScreenState extends ConsumerState<WorkGalleryScreen> {
  String? _selectedCategory;
  String? _selectedComplexity;

  List<WorkItemModel> _filterItems(List<WorkItemModel> items) {
    return items.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_selectedComplexity != null) {
        final complexityStr = item.complexity.name;
        if (complexityStr != _selectedComplexity) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(workGalleryProvider);
    final categoriesAsync = ref.watch(workCategoriesProvider);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('work_gallery'.i18n),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final result = await context.push<bool>('/work/add-work');
              if (result == true) {
                ref.invalidate(workGalleryProvider);
              }
            },
            child: Text(
              'add new work'.i18n,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats row
          itemsAsync.when(
            data: (items) {
              final totalViews = items.fold<int>(
                0,
                (sum, item) => sum + (item.views ?? 0),
              );
              final avgRating = items.isEmpty
                  ? 0.0
                  : items.fold<double>(
                          0,
                          (sum, item) => sum + (item.rating ?? 0),
                        ) /
                        items.length;
              return Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('${totalViews}', 'views'.i18n),
                    _buildStat(avgRating.toStringAsFixed(1), 'rating'.i18n),
                    _buildStat('${items.length}', 'works'.i18n),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(height: 80),
            error: (_, __) => const SizedBox(height: 80),
          ),
          // Category filters
          categoriesAsync.when(
            data: (categories) {
              return CategoryFilterChips(
                categories: categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() => _selectedCategory = category);
                },
              );
            },
            loading: () => const SizedBox(height: 40),
            error: (_, __) => const SizedBox(height: 40),
          ),
          const SizedBox(height: 16),
          // Work items list
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                final filtered = _filterItems(items);
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'no_work_items'.i18n,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () async {
                            final result = await context.push<bool>(
                              '/work/add-work',
                            );
                            if (result == true) {
                              ref.invalidate(workGalleryProvider);
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: Text('add_first_work'.i18n),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return WorkItemCard(
                      item: item,
                      onTap: () {
                        // فتح تفاصيل العمل
                      },
                      onDelete: () async {
                        final confirmed = await _showDeleteDialog(context);
                        if (confirmed) {
                          await ref
                              .read(workGalleryProvider.notifier)
                              .deleteWorkItem(item.id);
                        }
                      },
                    );
                  },
                );
              },
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('error loading gallery'.i18n),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(workGalleryProvider),
                      child: Text('retry'.i18n),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('delete_work'.i18n),
            content: Text('delete_work_confirmation'.i18n),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('cancel'.i18n),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('delete'.i18n),
              ),
            ],
          ),
        ) ??
        false;
  }
}
