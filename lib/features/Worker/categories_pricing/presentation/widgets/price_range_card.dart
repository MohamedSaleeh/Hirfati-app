import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../../domain/models/worker_category_model.dart';
import '../providers/categories_pricing_provider.dart';

class PriceRangeCard extends ConsumerStatefulWidget {
  final WorkerCategoryModel category;

  const PriceRangeCard({super.key, required this.category});

  @override
  ConsumerState<PriceRangeCard> createState() => _PriceRangeCardState();
}

class _PriceRangeCardState extends ConsumerState<PriceRangeCard> {
  late FormGroup _form;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'priceMin': FormControl<double>(
        value: widget.category.priceMin ?? 0,
        validators: [Validators.min(0)],
      ),
      'priceMax': FormControl<double>(
        value: widget.category.priceMax ?? 0,
        validators: [Validators.min(0)],
      ),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_form.invalid) return;

    final priceMin = _form.control('priceMin').value as double;
    final priceMax = _form.control('priceMax').value as double;

    await ref
        .read(categoriesPricingProvider.notifier)
        .updatePriceRange(priceMin, priceMax);

    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.attach_money,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.category.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_isEditing ? Icons.close : Icons.edit, size: 20),
                onPressed: () => setState(() => _isEditing = !_isEditing),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditing)
            ReactiveForm(
              formGroup: _form,
              child: Row(
                children: [
                  Expanded(
                    child: ReactiveTextField<double>(
                      formControlName: 'priceMin',
                      decoration: InputDecoration(
                        labelText: 'Min Price'.i18n,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        prefixText: '\$ ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      valueAccessor: DoubleValueAccessor(),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReactiveTextField<double>(
                      formControlName: 'priceMax',
                      decoration: InputDecoration(
                        labelText: 'Max Price'.i18n,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        prefixText: '\$ ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      valueAccessor: DoubleValueAccessor(),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 20,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                _buildPriceChip(
                  label: 'Min',
                  price: widget.category.priceMin ?? 0,
                ),
                const SizedBox(width: 12),
                _buildPriceChip(
                  label: 'Max',
                  price: widget.category.priceMax ?? 0,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPriceChip({required String label, required double price}) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '\$${price.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class DoubleValueAccessor extends ControlValueAccessor<double, String> {
  @override
  String modelToViewValue(double? modelValue) {
    return modelValue?.toString() ?? '';
  }

  @override
  double? viewToModelValue(String? viewValue) {
    if (viewValue == null || viewValue.isEmpty) return null;
    return double.tryParse(viewValue);
  }
}
