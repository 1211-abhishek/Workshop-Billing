import 'package:flutter/material.dart';
import '../models/billing_history.dart';
import '../widgets/bill_widget_preview.dart';
import 'package:pdf/pdf.dart';
import '../services/pdf_generator.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class BillPreviewScreen extends StatefulWidget {
  final BillingHistory billingHistory;
  const BillPreviewScreen({super.key, required this.billingHistory});

  @override
  State<BillPreviewScreen> createState() => _BillPreviewScreenState();
}

class _BillPreviewScreenState extends State<BillPreviewScreen> {
  bool isGenerating = true;
  Uint8List? _pdfBytes;

  @override
  void initState() {
    super.initState();
    _generatePdfInBackground();
  }

  void _generatePdfInBackground() async {
    try {
      final pdfBytes = await PdfGenerator.generateInvoice(widget.billingHistory, PdfPageFormat.a4);
      if (mounted) {
        setState(() {
          _pdfBytes = pdfBytes;
          isGenerating = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
      if (mounted) {
        setState(() => isGenerating = false);
      }
    }
  }

  Future<void> _printPdf() async {
    if (_pdfBytes == null) return;
    setState(() => isGenerating = true);
    try {
      await Printing.layoutPdf(onLayout: (_) async => _pdfBytes!);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error printing PDF: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isGenerating = false);
      }
    }
  }

  Future<void> _sharePdf() async {
    if (_pdfBytes == null) return;
    setState(() => isGenerating = true);
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/invoice_${widget.billingHistory.invoiceNumber}.pdf');
      await file.writeAsBytes(_pdfBytes!);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Invoice ${widget.billingHistory.invoiceNumber}',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing PDF: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bill Preview')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: BillWidgetPreview(billingHistory: widget.billingHistory)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: (!isGenerating && _pdfBytes != null) ? _printPdf : null,
                      icon: const Icon(Icons.print),
                      label: const Text('Print PDF'),
                    ),
                    ElevatedButton.icon(
                      onPressed: (!isGenerating && _pdfBytes != null) ? _sharePdf : null,
                      icon: const Icon(Icons.share),
                      label: const Text('Share PDF'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //if (isGenerating && _pdfBytes == null)
            // Container(
            //   color: Colors.black.withOpacity(0.1),
            //   child: const Center(child: CircularProgressIndicator()),
            // ),
        ],
      ),
    );
  }
}
