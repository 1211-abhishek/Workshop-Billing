import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/billing_history.dart';
import 'package:flutter_billing_system/widgets/bill_widget_preview.dart';

class BillPreviewScreenMobile extends StatelessWidget {
  final BillingHistory billingHistory;
  final bool isGenerating;
  final Uint8List? pdfBytes;
  final Function onPrint;
  final Function onShare;

  const BillPreviewScreenMobile({
    super.key,
    required this.billingHistory,
    required this.isGenerating,
    required this.pdfBytes,
    required this.onPrint,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(child: BillWidgetPreview(billingHistory: billingHistory)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: (!isGenerating && pdfBytes != null)
                        ? () => onPrint()
                        : null,
                    icon: const Icon(Icons.print),
                    label: const Text('Print PDF'),
                  ),
                  ElevatedButton.icon(
                    onPressed: (!isGenerating && pdfBytes != null)
                        ? () => onShare()
                        : null,
                    icon: const Icon(Icons.share),
                    label: const Text('Share PDF'),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isGenerating && pdfBytes == null)
          Container(
            color: Colors.black.withOpacity(0.1),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
