import 'package:flutter/material.dart';

/// Usage:
/// ResponsiveLayout(
///   mobile: WidgetA(),
///   tablet: WidgetB(),
///   desktop: WidgetC(),
/// )
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 500;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 500 && MediaQuery.of(context).size.width < 800;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 800;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 800 && desktop != null) {
      return desktop!;
    } else if (width >= 500 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
