import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_router/go_router.dart';
import '../../../../../translations.dart';
import '../providers/work_gallery_provider.dart';
import '../widgets/add_work_hero.dart';
import '../widgets/add_work_field_card.dart';
import '../widgets/add_work_photo_section.dart';

class AddWorkScreen extends ConsumerStatefulWidget {
  const AddWorkScreen({super.key});

  @override
  ConsumerState<AddWorkScreen> createState() => _AddWorkScreenState();
}

class _AddWorkScreenState extends ConsumerState<AddWorkScreen> {
  late FormGroup _form;
  bool _isSubmitting = false;
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'title': FormControl<String>(validators: [Validators.required]),
      'description': FormControl<String>(validators: [Validators.required]),
      'category': FormControl<String>(validators: [Validators.required]),
      'complexity': FormControl<String>(value: 'standard'),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please add at least one photo'.i18n),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(workGalleryProvider.notifier);
      final imagePaths = _selectedImages.map((img) => img.path).toList();

      await notifier.addWorkItem(
        title: _form.control('title').value as String,
        description: _form.control('description').value as String,
        imageUrls: imagePaths,
        category: _form.control('category').value as String,
        complexity: _form.control('complexity').value as String,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Work added successfully!'.i18n),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'.i18n),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(workCategoriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
          'add new work'.i18n,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submit,
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'publish'.i18n,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddWorkHero(),
            const SizedBox(height: 24),

            // Form
            ReactiveForm(
              formGroup: _form,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field
                    AddWorkFieldCard(
                      icon: Icons.title,
                      title: 'work title'.i18n,
                      child: ReactiveTextField<String>(
                        formControlName: 'title',
                        decoration: InputDecoration(
                          hintText: 'e.g., Modern Kitchen Renovation',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'title required'.i18n,
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description Field
                    AddWorkFieldCard(
                      icon: Icons.description,
                      title: 'work description'.i18n,
                      child: ReactiveTextField<String>(
                        formControlName: 'description',
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'tell us about your work'.i18n,
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'description required'.i18n,
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category & Complexity Row
                    Row(
                      children: [
                        Expanded(
                          child: AddWorkFieldCard(
                            icon: Icons.category,
                            title: 'category'.i18n,
                            child: categoriesAsync.when(
                              data: (categories) {
                                return ReactiveDropdownField<String>(
                                  formControlName: 'category',
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.3),
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                  items: categories.map((cat) {
                                    return DropdownMenuItem(
                                      value: cat.name,
                                      child: Text(
                                        cat.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  validationMessages: {
                                    ValidationMessage.required: (_) =>
                                        'category required'.i18n,
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
                              error: (_, __) => Text('Error'.i18n),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AddWorkFieldCard(
                            icon: Icons.tune,
                            title: 'complexity'.i18n,
                            child: ReactiveDropdownField<String>(
                              formControlName: 'complexity',
                              isExpanded: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.3),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'standard',
                                  child: Text('Standard'.i18n),
                                ),
                                DropdownMenuItem(
                                  value: 'high',
                                  child: Text('High Complexity'.i18n),
                                ),
                                DropdownMenuItem(
                                  value: 'critical',
                                  child: Text('Critical Task'.i18n),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Photos Section
                    AddWorkPhotoSection(
                      images: _selectedImages,
                      onAddPhotos: _pickImages,
                      onRemovePhoto: _removeImage,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
