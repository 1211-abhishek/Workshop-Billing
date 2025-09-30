import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import 'admin_screen.dart';
import 'billing_screen.dart';
import '../responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Billing System',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
              );
            },
            tooltip: 'Admin Panel',
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildMobile(context),
        tablet: _buildTablet(context),
        desktop: _buildDesktop(context),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CustomCard(
            icon: Icons.receipt_long_rounded,
            title: 'Create New Bill',
            subtitle: 'Generate a new invoice for a customer',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BillingScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          CustomCard(
            icon: Icons.admin_panel_settings_rounded,
            title: 'Admin Panel',
            subtitle: 'Manage products, customers, and view reports',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withAlpha(12),
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
              children: _homeCards(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withAlpha(12),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 48.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            childAspectRatio: 1.5,
            children: _homeCards(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _homeCards(BuildContext context) {
    return [
       CustomCard(
        icon: Icons.receipt_long_rounded,
        title: 'Create New Bill',
        subtitle: 'Generate a new invoice for a customer',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BillingScreen()),
          );
        },
      ),
      CustomCard(
        icon: Icons.admin_panel_settings_rounded,
        title: 'Admin Panel',
        subtitle: 'Manage products, customers, and view reports',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen()),
          );
        },
      ),
    ];
  }
}
