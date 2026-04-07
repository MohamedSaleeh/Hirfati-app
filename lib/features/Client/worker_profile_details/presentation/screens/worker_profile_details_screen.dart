import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../../translations.dart';
import '../providers/worker_profile_controller.dart';
import '../widgets/worker_favorite_button.dart';
import '../widgets/worker_portfolio_preview.dart';
import '../widgets/worker_profile_header.dart';
import '../widgets/worker_profile_tabs.dart';
import '../widgets/worker_request_service_button.dart';
import '../widgets/worker_reviews_preview.dart';
import '../widgets/worker_services_preview.dart';

class WorkerProfileDetailsScreen extends ConsumerStatefulWidget {
  final String workerId;

  const WorkerProfileDetailsScreen({super.key, required this.workerId});

  @override
  ConsumerState<WorkerProfileDetailsScreen> createState() =>
      _WorkerProfileDetailsScreenState();
}

class _WorkerProfileDetailsScreenState
    extends ConsumerState<WorkerProfileDetailsScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(workerProfileControllerProvider(widget.workerId));
    final controller = ref.read(
      workerProfileControllerProvider(widget.workerId).notifier,
    );

    final details = state.details;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        elevation: 0,
        title: Text('Worker Profile Details'.i18n),
        actions: [
          if (details != null)
            WorkerFavoriteButton(
              isFavorite: details.isFavorite,
              onTap: () => controller.toggleFavorite(widget.workerId),
            ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share, color: theme.colorScheme.onSurface),
          ),
        ],
      ),
      body: state.isLoading
          ? Center(
              child: Lottie.asset(
                'assets/animations/loading_animation.json',
                width: 150,
                height: 150,
                repeat: true,
              ),
            )
          : state.errorMessage != null
          ? Center(child: Text(state.errorMessage!.i18n))
          : details == null
          ? Center(child: Text('No data found'.i18n))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WorkerProfileHeader(details: details),
                        const SizedBox(height: 16),
                        WorkerProfileTabs(
                          currentIndex: _tabIndex,
                          onChanged: (index) {
                            setState(() => _tabIndex = index);
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_tabIndex == 0)
                          WorkerPortfolioPreview(
                            items: state.portfolio,
                            onViewAll: () {},
                          ),
                        if (_tabIndex == 1)
                          WorkerServicesPreview(services: state.services),
                        if (_tabIndex == 2)
                          WorkerReviewsPreview(reviews: state.reviews),
                      ],
                    ),
                  ),
                ),
                WorkerRequestServiceButton(
                  startsFrom: details.priceMin,
                  onPressed: () {},
                ),
              ],
            ),
    );
  }
}
