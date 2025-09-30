import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../ui/responsive/home_screen_desktop.dart';
import '../ui/responsive/home_screen_mobile.dart';
import '../ui/responsive/home_screen_tablet.dart';
import 'admin_screen.dart';

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
        title: Text(
          'Billing System',
          style: Theme.of(context).textTheme.headlineSmall,
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
      body: Container(
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
          padding: const EdgeInsets.all(24.0),
          child: ScreenTypeLayout.builder(
            mobile: (BuildContext context) => const HomeScreenMobile(),
            tablet: (BuildContext context) => const HomeScreenTablet(),
            desktop: (BuildContext context) => const HomeScreenDesktop(),
          ),
        ),
      ),
    );
  }
}
