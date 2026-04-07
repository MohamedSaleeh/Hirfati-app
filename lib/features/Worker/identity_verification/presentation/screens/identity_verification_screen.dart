import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../../domain/models/verification_request_model.dart';
import '../providers/identity_verification_provider.dart';
import '../widgets/face_upload_card.dart';
import '../widgets/id_upload_card.dart';
import '../widgets/verification_guidelines.dart';
import '../widgets/verification_status_card.dart';

class IdentityVerificationScreen extends ConsumerStatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  ConsumerState<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends ConsumerState<IdentityVerificationScreen> {
  late FormGroup _form;
  bool _isSubmitting = false;

  String? _nationalIdFrontUrl;
  String? _nationalIdBackUrl;
  String? _passportUrl;
  String? _driversLicenseUrl;
  String? _selfieUrl;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'fullName': FormControl<String>(validators: [Validators.required]),
      'age': FormControl<int>(
        validators: [
          Validators.required,
          Validators.min(18),
          Validators.max(100),
        ],
      ),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  bool get _hasDocuments {
    return (_nationalIdFrontUrl != null && _nationalIdBackUrl != null) ||
        _passportUrl != null ||
        _driversLicenseUrl != null;
  }

  Future<void> _submit() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }

    if (!_hasDocuments) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('upload_id_document'.i18n.replaceAll('_', ' '))),
      );
      return;
    }

    if (_selfieUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('take_selfie'.i18n.replaceAll('_', ' '))),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(identityVerificationProvider.notifier);

      String? nationalIdUrl;
      String? passportUrl;
      String? driversLicenseUrl;

      if (_nationalIdFrontUrl != null && _nationalIdBackUrl != null) {
        nationalIdUrl =
            'front:${_nationalIdFrontUrl}|back:${_nationalIdBackUrl}';
      }
      if (_passportUrl != null) passportUrl = _passportUrl;
      if (_driversLicenseUrl != null) driversLicenseUrl = _driversLicenseUrl;

      final success = await notifier.submitVerification(
        fullName: _form.control('fullName').value as String,
        age: _form.control('age').value as int,
        email: _form.control('email').value as String,
        nationalIdUrl: nationalIdUrl,
        passportUrl: passportUrl,
        driversLicenseUrl: driversLicenseUrl,
        selfieUrl: _selfieUrl,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('verification_submitted'.i18n.replaceAll('_', ' ')),
            backgroundColor: colorScheme.tertiary,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error_submitting'.i18n.replaceAll('_', ' ')),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<String?> _uploadDocument(String type, [String? imagePath]) async {
    final notifier = ref.read(identityVerificationProvider.notifier);
    final picker = ref.read(imagePickerProvider);

    String? path = imagePath;

    if (path == null) {
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image == null) return null;
      path = image.path;
    }

    return await notifier.uploadDocument(type, path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final requestAsync = ref.watch(identityVerificationProvider);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(
          'identity_verification'.i18n.replaceAll('_', ' '),
          style: TextStyle(color: colorScheme.onSurface),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: colorScheme.primary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: requestAsync.when(
        data: (request) {
          if (request != null &&
              request.status != VerificationStatus.rejected) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  VerificationStatusCard(request: request),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: ReactiveForm(
              formGroup: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified_user,
                          size: 48,
                          color: colorScheme.onPrimary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'unlock_professional_growth'.i18n.replaceAll(
                            '_',
                            ' ',
                          ),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'verification_benefits'.i18n.replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onPrimary.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'personal_information'.i18n.replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ReactiveTextField<String>(
                          formControlName: 'fullName',
                          decoration: InputDecoration(
                            labelText: 'full_legal_name'.i18n.replaceAll(
                              '_',
                              ' ',
                            ),
                            labelStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest,
                          ),
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'name_required'.i18n,
                          },
                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField<int>(
                          formControlName: 'age',
                          decoration: InputDecoration(
                            labelText: 'age'.i18n,
                            labelStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            hintText: 'dd/mm/yyyy',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest,
                          ),
                          keyboardType: TextInputType.number,
                          valueAccessor: _IntValueAccessor(),
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'age_required'.i18n,
                            ValidationMessage.min: (_) => 'age_min'.i18n,
                            ValidationMessage.max: (_) => 'age_max'.i18n,
                          },
                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField<String>(
                          formControlName: 'email',
                          decoration: InputDecoration(
                            labelText: 'email'.i18n,
                            labelStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'email_required'.i18n,
                            ValidationMessage.email: (_) =>
                                'email_invalid'.i18n,
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  IdUploadCard(
                    title: 'id_document'.i18n,
                    onFrontUploaded: (url) async {
                      if (url != null) {
                        final uploadedUrl = await _uploadDocument(
                          'national_id_front',
                          url,
                        );
                        if (uploadedUrl != null) {
                          setState(() => _nationalIdFrontUrl = uploadedUrl);
                        }
                      }
                    },
                    onBackUploaded: (url) async {
                      if (url != null) {
                        final uploadedUrl = await _uploadDocument(
                          'national_id_back',
                          url,
                        );
                        if (uploadedUrl != null) {
                          setState(() => _nationalIdBackUrl = uploadedUrl);
                        }
                      }
                    },
                    frontUploaded: _nationalIdFrontUrl != null,
                    backUploaded: _nationalIdBackUrl != null,
                  ),
                  const SizedBox(height: 16),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'alternative_documents'.i18n.replaceAll('_', ' '),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'optional'.i18n.replaceAll('_', ' '),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildAlternativeDocumentItem(
                          title: 'passport'.i18n,
                          isUploaded: _passportUrl != null,
                          onTap: () async {
                            final url = await _uploadDocument('passport');
                            if (url != null) setState(() => _passportUrl = url);
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildAlternativeDocumentItem(
                          title: 'drivers_license'.i18n,
                          isUploaded: _driversLicenseUrl != null,
                          onTap: () async {
                            final url = await _uploadDocument(
                              'drivers_license',
                            );
                            if (url != null)
                              setState(() => _driversLicenseUrl = url);
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'alternative_documents_note'.i18n.replaceAll(
                            '_',
                            ' ',
                          ),
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  FaceUploadCard(
                    isUploaded: _selfieUrl != null,
                    onUpload: (url) async {
                      if (url != null) {
                        final uploadedUrl = await _uploadDocument(
                          'selfie',
                          url,
                        );
                        if (uploadedUrl != null) {
                          setState(() => _selfieUrl = uploadedUrl);
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  const VerificationGuidelines(),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'submit for verification'.i18n,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
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
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'error_loading'.i18n.replaceAll('_', ' '),
                style: TextStyle(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(identityVerificationProvider),
                child: Text('retry'.i18n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlternativeDocumentItem({
    required String title,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUploaded
              ? colorScheme.primaryContainer.withOpacity(0.3)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isUploaded ? Icons.check_circle : Icons.upload_file,
              color: isUploaded
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isUploaded
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isUploaded ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _IntValueAccessor extends ControlValueAccessor<int, String> {
  @override
  String modelToViewValue(int? modelValue) => modelValue?.toString() ?? '';

  @override
  int? viewToModelValue(String? viewValue) {
    if (viewValue == null || viewValue.isEmpty) return null;
    return int.tryParse(viewValue);
  }
}
