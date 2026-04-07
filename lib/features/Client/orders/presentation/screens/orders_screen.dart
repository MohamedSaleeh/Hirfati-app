import 'package:flutter/material.dart';
import 'package:hirfati/translations.dart';
import '../../../../../core/models/order.dart';
import '../widgets/orders_tabs_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Orders'.i18n,
            style: TextStyle(color: colorScheme.onSurface),
          ),
          centerTitle: true,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            tabs: [
              Tab(text: 'pending'.i18n),
              Tab(text: 'Completed'.i18n),
              Tab(text: 'Cancelled'.i18n),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrdersTabsWidget(status: OrderStatus.pending),
            OrdersTabsWidget(status: OrderStatus.completed),
            OrdersTabsWidget(status: OrderStatus.cancelled),
          ],
        ),
      ),
    );
  }
}
