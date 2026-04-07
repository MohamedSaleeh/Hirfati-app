import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../translations.dart';
import '../../../../notifications/presentation/providers/notifications_stream_provider.dart';
import '../../../earnings/presentation/providers/earnings_provider.dart';
import '../../../incoming_orders/presentation/providers/incoming_orders_provider.dart';
import '../../../incoming_orders/presentation/widgets/incoming_order_card.dart';
import '../../../worker_profile/presentation/providers/worker_profile_provider.dart';
import '../providers/active_jobs_provider.dart';
import '../providers/incoming_orders_provider.dart' hide incomingOrdersProvider;
import '../providers/worker_dashboard_provider.dart';
import '../widgets/active_job_card.dart';
import '../widgets/availability_toggle.dart';
import '../widgets/worker_stat_card.dart';

class WorkerDashboardScreen extends ConsumerWidget {
  const WorkerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final dashboardAsync = ref.watch(workerDashboardProvider);
    final incomingOrdersAsync = ref.watch(incomingOrdersProvider);
    final activeJobsAsync = ref.watch(activeJobsProvider);
    final orderActions = ref.read(incomingOrdersActionsProvider);
    final unreadCountStream = ref.watch(unreadNotificationsCountStreamProvider);
    final unreadCount = unreadCountStream.value ?? 0;
    final user = Supabase.instance.client.auth.currentUser;
    final userName = user?.userMetadata?['full_name'] as String? ?? 'User';

    final profileAsync = ref.watch(workerProfileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(
          'welcome_back'.i18n.replaceAll('_', ' ') + ' \n$userName',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/notifications');
            },
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: colorScheme.onSurface,
                  size: 28,
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            splashRadius: 20,
          ),
          const SizedBox(width: 8),

          profileAsync.when(
            data: (profile) {
              return GestureDetector(
                onTap: () => context.push('/worker/profile'),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: profile.avatarUrl != null
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.grey.shade400,
                        )
                      : null,
                ),
              );
            },
            error: (err, stackTrace) =>
                Text('Error loading profile: \$err'.i18n),
            loading: () => Lottie.asset(
              'assets/animations/loading_animation.json',
              width: 150,
              height: 150,
              repeat: true,
            ),
          ),
          const SizedBox(width: 8),
          const SizedBox(width: 16),
        ],
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(workerDashboardProvider);
          ref.invalidate(incomingOrdersProvider);
          ref.invalidate(activeJobsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AvailabilityToggle(),
              const SizedBox(height: 16),

              // Stats
              dashboardAsync.when(
                data: (data) => Row(
                  children: [
                    Expanded(
                      child: WorkerStatCard(
                        title: 'active orders'.i18n,
                        value: data.totalActiveJobs.toString(),
                        icon: Icons.assignment_turned_in,
                        subtitle: 'order'.i18n,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: WorkerStatCard(
                        title: 'today earnings'.i18n,
                        value: data.totalEarnings.toStringAsFixed(0),
                        icon: Icons.account_balance_wallet,
                        subtitle: '\$',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                loading: () => Center(
                  child: Lottie.asset(
                    'assets/animations/loading_animation.json',
                    width: 150,
                    height: 150,
                    repeat: true,
                  ),
                ),
                error: (err, stack) => Text('Error loading stats: \$err'.i18n),
              ),
              const SizedBox(height: 24),

              // Incoming Orders Section
              Text(
                'new requests'.i18n,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              incomingOrdersAsync.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 48,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text('new requests unavailable'.i18n),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return IncomingOrderCard(
                        order: order,
                        onAccept: () async {
                          try {
                            await orderActions.acceptOrder(order.id);
                            ref.invalidate(incomingOrdersProvider);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'order_accepted_successfully'.i18n
                                        .replaceAll('_', ' '),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('error: \$e'.i18n)),
                              );
                            }
                          }
                        },
                        onReject: () async {
                          try {
                            await orderActions.rejectOrder(order.id);
                            ref.invalidate(incomingOrdersProvider);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('error: \$e'.i18n)),
                              );
                            }
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
                error: (err, stack) => Text('Error loading orders: \$err'.i18n),
              ),
              const SizedBox(height: 24),

              // Active Jobs Section
              Text(
                'active jobs'.i18n,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              activeJobsAsync.when(
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.work_off_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'no active jobs'.i18n,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return ActiveJobCard(
                        order: job,
                        onTap: () {
                          context.push('/order-details/${job.id}', extra: job);
                        },
                        onStart: () async {
                          try {
                            await orderActions.changeOrderStatus(
                              job.id,
                              'in_progress',
                            );
                            ref.invalidate(activeJobsProvider);
                            ref.invalidate(incomingOrdersActionsProvider);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('job started'.i18n),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('error: $e'.i18n)),
                              );
                            }
                          }
                        },
                        onComplete: () async {
                          try {
                            await orderActions.completeOrder(job.id);
                            ref.invalidate(activeJobsProvider);
                            ref.invalidate(workerDashboardProvider);
                            ref.invalidate(earningsProvider);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'job_completed'.i18n.replaceAll('_', ' '),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('error: $e'.i18n)),
                              );
                            }
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
                error: (err, stack) =>
                    Text('Error loading active jobs: \$err'.i18n),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
