import 'package:flutter/material.dart';
import 'package:flutter_billing_system/screens/billing_screen.dart';
import 'package:flutter_billing_system/screens/manage_customers_screen.dart';
import 'package:flutter_billing_system/screens/manage_inventory_screen.dart';
import 'package:flutter_billing_system/screens/reports_screen.dart';

class HomeScreenDesktop extends StatelessWidget {
  const HomeScreenDesktop({super.key});

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
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 64),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: gridItems.map((item) {
              return Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => item['screen']),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'],
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            item['title'],
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
