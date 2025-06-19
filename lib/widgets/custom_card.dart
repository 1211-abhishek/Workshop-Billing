import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const CustomCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double cardWidth;
    double cardHeight;
    double iconSize;
    double padding;
    if (width < 500) {
      cardWidth = double.infinity;
      cardHeight = 160;
      iconSize = 25;
      padding = 12;
    } else if (width < 800) {
      cardWidth = 320;
      cardHeight = 210;
      iconSize = 30;
      padding = 16;
    } else {
      cardWidth = 360;
      cardHeight = 220;
      iconSize = 40;
      padding = 20;
    }
    return Center(
      child: SizedBox(
        width: cardWidth == double.infinity ? null : cardWidth,
        height: cardHeight,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          margin: const EdgeInsets.all(8),
          shadowColor: Colors.black.withOpacity(0.1),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(padding / 2),
                        decoration: BoxDecoration(
                          color: (iconColor ?? Theme.of(context).colorScheme.primary)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          icon,
                          size: iconSize,
                          color: iconColor ?? Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      flex: 1,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: width < 500 ? 16 : width < 800 ? 18 : 20,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      flex: 1,
                      child: Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: width < 500 ? 12 : 14,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}