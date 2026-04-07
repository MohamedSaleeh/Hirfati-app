import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/Worker/earnings/presentation/screens/earnings_screen.dart';
import '../../../features/Worker/incoming_orders/presentation/screens/incoming_orders_screen.dart';
import '../../../features/Worker/work_gallery/presentation/screens/work_gallery_screen.dart';
import '../../../features/Worker/worker_home/presentation/providers/worker_navigation_provider.dart';
import '../../../features/Worker/worker_home/presentation/widgets/worker_bottom_nav_bar.dart';

import '../../../features/Worker/worker_home/presentation/screens/worker_dashboard_screen.dart';
import '../../../features/chat/presentation/screens/conversations_screen.dart';

class HomeScreenWorker extends ConsumerWidget {
  const HomeScreenWorker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(workerNavIndexProvider);
    final List<Widget> pages = [
      const WorkerDashboardScreen(),
      const IncomingOrdersScreen(),
      const EarningsScreen(),
      const WorkGalleryScreen(),
      const ConversationsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: const WorkerBottomNavBar(),
    );
  }
}
