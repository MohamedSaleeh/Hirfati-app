import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/order.dart';
import '../../../../translations.dart';
import '../providers/review_provider.dart';
import '../providers/review_rating_provider.dart';
import '../providers/review_form_provider.dart';
import '../widgets/review_worker_info.dart';
import '../widgets/review_comment_section.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final Order order;

  const ReviewScreen({super.key, required this.order});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  late String _orderId;
  late String _workerId;
  late String _clientId;

  @override
  void initState() {
    super.initState();

    _orderId = widget.order.id;
    _workerId = widget.order.workerId;

    final currentUser = Supabase.instance.client.auth.currentUser;
    _clientId = currentUser?.id ?? '';

    print('📝 ReviewScreen initState:');
    print('   - orderId: $_orderId');
    print('   - workerId: $_workerId');
    print('   - clientId: $_clientId');

    Future.microtask(() {
      if (mounted) {
        ref.read(reviewOrderIdProvider.notifier).state = _orderId;
        ref.read(reviewWorkerIdProvider.notifier).state = _workerId;
        ref.read(reviewClientIdProvider.notifier).state = _clientId;
      }
    });

    Future.microtask(() {
      if (mounted) {
        final form = ref.read(reviewFormProvider);
        form.control('comment').reset();
        ref.read(reviewRatingProvider.notifier).state = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasReviewedAsync = ref.watch(hasReviewedProvider(_orderId));

    return hasReviewedAsync.when(
      data: (hasReviewed) {
        return _buildReviewForm();
      },
      loading: () => Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 150,
            height: 150,
            repeat: true,
          ),
        ),
      ),
      error: (error, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading review status'.i18n,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(hasReviewedProvider(_orderId));
                },
                child: Text('Retry'.i18n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewForm() {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Your Experience'.i18n),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ReviewWorkerInfo(order: widget.order),
            const SizedBox(height: 24),
            _buildRatingSection(),
            const SizedBox(height: 24),
            ReviewCommentSection(form: ref.watch(reviewFormProvider)),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    final theme = Theme.of(context);
    final rating = ref.watch(reviewRatingProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            'How was your experience?'.i18n,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 48.0,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
                Icon(Icons.star, color: theme.colorScheme.tertiary),
            onRatingUpdate: (newRating) {
              if (mounted) {
                ref.read(reviewRatingProvider.notifier).state = newRating;
              }
            },
          ),
          const SizedBox(height: 12),
          Text(
            _getRatingText(rating),
            style: TextStyle(
              color: rating > 0
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final theme = Theme.of(context);
    final isSubmitting = ref.watch(reviewIsSubmittingProvider);
    final rating = ref.watch(reviewRatingProvider);
    final comment = ref.watch(reviewCommentValueProvider) ?? '';
    final isFormValid = rating > 0;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (isFormValid && !isSubmitting)
            ? () => _submitReview(rating.toInt(), comment)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSubmitting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : Text('Submit Review'.i18n),
      ),
    );
  }

  Future<void> _submitReview(int rating, String comment) async {
    final theme = Theme.of(context);

    if (!mounted) return;

    final orderId = ref.read(reviewOrderIdProvider);
    final workerId = ref.read(reviewWorkerIdProvider);
    final clientId = ref.read(reviewClientIdProvider);

    if (orderId == null || workerId == null || clientId == null) {
      print('❌ Missing required IDs for review');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please wait, loading...'.i18n),
          backgroundColor: theme.colorScheme.tertiary,
        ),
      );
      return;
    }

    ref.read(reviewIsSubmittingProvider.notifier).state = true;

    print('📤 Submitting review: rating=$rating, comment=$comment');

    try {
      final notifier = ref.read(reviewProvider.notifier);
      final success = await notifier.submitReview(
        rating: rating,
        comment: comment,
      );

      if (!mounted) return;

      if (success) {
        ref.invalidate(hasReviewedProvider(_orderId));

        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you for your review!'.i18n),
            backgroundColor: theme.colorScheme.primary,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting review'.i18n),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    } catch (e) {
      print('❌ Error in _submitReview: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'.i18n),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        ref.read(reviewIsSubmittingProvider.notifier).state = false;
      }
    }
  }

  String _getRatingText(double rating) {
    if (rating >= 4.5) return 'Excellent!';
    if (rating >= 3.5) return 'Good';
    if (rating >= 2.5) return 'Average';
    if (rating >= 1.5) return 'Below Average';
    if (rating > 0) return 'Poor';
    return 'Select rating';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
