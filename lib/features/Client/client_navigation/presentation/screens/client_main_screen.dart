import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Home_client/presentation/screens/home_screen_client.dart';
import '../../../map_discovery/presentation/screens/map_discovery_screen.dart';
import '../../../orders/presentation/screens/orders_screen.dart';
import '../providers/client_navigation_provider.dart';
import '../widgets/client_bottom_navigation_bar.dart';
import 'chat_list_screen.dart';

import '../../../profile/presentation/screens/client_profile_screen.dart';

class ClientMainScreen extends ConsumerWidget {
  const ClientMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(clientNavigationProvider);

    const List<Widget> pages = [
      HomeScreenClient(),
      OrdersScreen(),
      MapDiscoveryScreen(),
      ChatListScreen(),
      ClientProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: const ClientBottomNavigationBar(),
    );
  }
}
