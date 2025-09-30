import 'package:flutter/material.dart';
import 'package:flutter_billing_system/screens/billing_screen.dart';
import 'package:flutter_billing_system/screens/manage_customers_screen.dart';
import 'package:flutter_billing_system/screens/manage_inventory_screen.dart';
import 'package:flutter_billing_system/screens/reports_screen.dart';

class HomeScreenTablet extends StatelessWidget {
  const HomeScreenTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridItems = [
      {
        'title': 'New Bill',
        'icon': Icons.add_shopping_cart_rounded,
        'screen': const BillingScreen(),
      },
      {
        'title': 'Inventory',
        'icon': Icons.inventory_2_rounded,
        'screen': const ManageInventoryScreen(),
      },
      {
        'title': 'Customers',
        'icon': Icons.people_rounded,
        'screen': const ManageCustomersScreen(),
      },
      {
        'title': 'Reports',
        'icon': Icons.bar_chart_rounded,
        'screen': const ReportsScreen(),
      },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome to your Billing System',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 48),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
            ),
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              final item = gridItems[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item['screen']),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        item['title'],
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
