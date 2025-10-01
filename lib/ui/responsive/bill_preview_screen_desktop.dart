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
    return Stack(
      children: [
        Row(
          children: [
            Expanded(child: BillWidgetPreview(billingHistory: billingHistory)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: (!isGenerating && pdfBytes != null)
                        ? () => onPrint()
                        : null,
                    icon: const Icon(Icons.print),
                    label: const Text('Print PDF'),
                  ),
                  const SizedBox(height: 16),
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
            color: Colors.black.withAlpha(25),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
