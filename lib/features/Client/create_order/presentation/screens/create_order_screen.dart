import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/progress_stepper.dart';
import '../../../../../translations.dart';
import '../providers/create_order_provider.dart';
import 'step1_description_screen.dart';
import 'step2_photos_screen.dart';
import 'step3_location_screen.dart';
import 'step4_summary_screen.dart';

class CreateOrderScreen extends ConsumerStatefulWidget {
  final String? workerId;
  final String? serviceId;
  final String? serviceName;
  final double? estimatedPrice;

  const CreateOrderScreen({
    super.key,
    this.workerId,
    this.serviceId,
    this.serviceName,
    this.estimatedPrice,
  });

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workerId = widget.workerId;
      if (workerId == null || workerId.isEmpty) return;
      ref
          .read(createOrderProvider.notifier)
          .bindBookingContext(
            workerId: workerId,
            serviceId: widget.serviceId ?? '',
            serviceName: widget.serviceName ?? '',
            estimatedPrice: widget.estimatedPrice ?? 0,
          );
    });
  }

  void _showValidationError(
    BuildContext context,
    int currentStep,
    bool isDirectBooking,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    String errorMessage = '';

    switch (currentStep) {
      case 0:
        if (isDirectBooking) {
          errorMessage = 'Please select a service to continue'.i18n;
        } else {
          errorMessage =
              'Please select a category and describe your issue (minimum 20 characters)'
                  .i18n;
        }
        break;
      case 1:
        errorMessage = 'Please add at least one photo to continue'.i18n;
        break;
      case 2:
        errorMessage = 'Please set your location and preferred time'.i18n;
        break;
      default:
        errorMessage = 'Please complete all required fields'.i18n;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colorScheme.onError,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(errorMessage)),
          ],
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(createOrderProvider);
    final notifier = ref.read(createOrderProvider.notifier);

    final screens = const [
      Step1DescriptionScreen(),
      Step2PhotosScreen(),
      Step3LocationScreen(),
      Step4SummaryScreen(),
    ];

    final canContinue = notifier.validateStep(state.currentStep);
    final isLast = state.currentStep == screens.length - 1;
    final isDirectBooking = state.isDirectBooking;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Service Request'.i18n),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Step ${state.currentStep + 1} ${'of'.i18n} ${screens.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (state.currentStep == 1 && state.order.photos.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 14,
                            color: colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Photos required'.i18n,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onErrorContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ProgressStepper(currentStep: state.currentStep, totalSteps: 4),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: KeyedSubtree(
                    key: ValueKey(state.currentStep),
                    child: screens[state.currentStep],
                  ),
                ),
              ),
              if (state.errorMessage != null && state.errorMessage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: colorScheme.onErrorContainer,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.errorMessage!,
                            style: TextStyle(
                              color: colorScheme.onErrorContainer,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: state.currentStep == 0
                          ? () => Navigator.of(context).pop()
                          : notifier.previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        state.currentStep == 0 ? 'Cancel'.i18n : 'Back'.i18n,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () async {
                              if (isLast) {
                                if (notifier.validateStep(3)) {
                                  final ok = await notifier.submitOrder();
                                  if (ok && context.mounted) {
                                    final theme = Theme.of(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Request submitted successfully'
                                                  .i18n,
                                            ),
                                          ],
                                        ),
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  _showValidationError(
                                    context,
                                    state.currentStep,
                                    isDirectBooking,
                                  );
                                }
                                return;
                              }

                              if (canContinue) {
                                notifier.nextStep();
                              } else {
                                _showValidationError(
                                  context,
                                  state.currentStep,
                                  isDirectBooking,
                                );
                              }
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isSubmitting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : Text(
                              isLast ? 'Submit Request'.i18n : 'Next Step'.i18n,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (state.currentStep == 1 && state.order.photos.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: Text(
                      'Tap the + button to add photos of the issue'.i18n,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
