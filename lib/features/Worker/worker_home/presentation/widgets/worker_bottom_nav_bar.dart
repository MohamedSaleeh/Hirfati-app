import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../translations.dart';
import '../providers/worker_navigation_provider.dart';

class WorkerBottomNavBar extends ConsumerWidget {
  const WorkerBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(workerNavIndexProvider);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        ref.read(workerNavIndexProvider.notifier).state = index;
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: 'home'.i18n,
        ),

        NavigationDestination(
          icon: const Icon(Icons.receipt_long_outlined),
          selectedIcon: const Icon(Icons.receipt_long),
          label: 'orders'.i18n,
        ),
        NavigationDestination(
          icon: const Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: const Icon(Icons.account_balance_wallet),
          label: 'earnings'.i18n,
        ),
        NavigationDestination(
          icon: const Icon(Icons.photo_library_outlined),
          selectedIcon: const Icon(Icons.photo_library),
          label: 'Work Gallery'.i18n,
        ),
        NavigationDestination(
          icon: const Icon(Icons.message_outlined),
          selectedIcon: const Icon(Icons.message),
          label: 'messages'.i18n,
        ),
      ],
    );
  }
}
