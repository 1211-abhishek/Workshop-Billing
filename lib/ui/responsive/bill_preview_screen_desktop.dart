import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/billing_history.dart';
import 'package:flutter_billing_system/widgets/bill_widget_preview.dart';

class BillPreviewScreenDesktop extends StatelessWidget {
  final BillingHistory billingHistory;
  final bool isGenerating;
  final Uint8List? pdfBytes;
  final Function onPrint;
  final Function onShare;

  const BillPreviewScreenDesktop({
    super.key,
    required this.billingHistory,
    required this.isGenerating,
    required this.pdfBytes,
    required this.onPrint,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BillWidgetPreview(billingHistory: billingHistory),
          if (isGenerating && pdfBytes == null)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Generating PDF...', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: isGenerating
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () => onShare(),
                    heroTag: 'share_fab',
                    tooltip: 'Share PDF',
                    child: const Icon(Icons.share),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    onPressed: () => onPrint(),
                    heroTag: 'print_fab',
                    tooltip: 'Print PDF',
                    child: const Icon(Icons.print),
                  ),
                ],
              ),
            ),
    );
  }
}
