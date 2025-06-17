import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:open_filex/open_filex.dart';
import '../models/billing_history.dart';
import '../services/pdf_generator.dart';
import '../responsive_layout.dart';

class PdfInvoiceScreen extends StatefulWidget {
  final BillingHistory billingHistory;

  const PdfInvoiceScreen({
    super.key,
    required this.billingHistory,
  });

  @override
  State<PdfInvoiceScreen> createState() => _PdfInvoiceScreenState();
}

class _PdfInvoiceScreenState extends State<PdfInvoiceScreen> {
  bool isGenerating = false;
  String? lastSavedPath; // Store last saved path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice ${widget.billingHistory.invoiceNumber}'),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobile(context),
        tablet: _buildTablet(context),
        desktop: _buildDesktop(context),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return _mainContent(context, padding: 16);
  }

  Widget _buildTablet(BuildContext context) {
    return _mainContent(context, padding: 48);
  }

  Widget _buildDesktop(BuildContext context) {
    return _mainContent(context, padding: 120);
  }

  Widget _mainContent(BuildContext context, {required double padding}) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          if (isGenerating)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else ...[
            Expanded(
              child: PdfPreview(
                build: (format) => _generatePdf(format),
                allowPrinting: true,
                allowSharing: true,
                canChangePageFormat: false,
                canDebug: false,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (lastSavedPath != null)
                  ElevatedButton.icon(
                    onPressed: _openInvoice,
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Open PDF'),
                  ),
                ElevatedButton.icon(
                  onPressed: _shareInvoice,
                  icon: const Icon(Icons.share_rounded),
                  label: const Text('Share Invoice'),
                ),
                ElevatedButton.icon(
                  onPressed: _saveInvoice,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Save Invoice'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    debugPrint('[PDF] _generatePdf called');

    try {
      final pdfBytes = await PdfGenerator.generateInvoice(
        widget.billingHistory,
        format,
      );
      debugPrint('[PDF] PDF generated successfully');
      return pdfBytes;
    } catch (e) {
      debugPrint('[PDF][ERROR] Error generating PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
      rethrow;
    }
  }

  Future<void> _shareInvoice() async {
    debugPrint('[PDF] _shareInvoice called');
    setState(() => isGenerating = true);

    try {
      if (kIsWeb) {
        final pdfBytes = await PdfGenerator.generateInvoice(
          widget.billingHistory,
          PdfPageFormat.a4,
        );
        await Printing.sharePdf(
          bytes: pdfBytes,
          filename: 'Invoice-${widget.billingHistory.invoiceNumber}.pdf',
        );
      } else {
        await PdfGenerator.shareInvoice(widget.billingHistory);
      }
      debugPrint('[PDF] Invoice shared');
    } catch (e) {
      debugPrint('[PDF][ERROR] Error sharing invoice: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing invoice: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isGenerating = false);
    }
  }

  Future<void> _saveInvoice() async {
    debugPrint('[PDF] _saveInvoice called');
    setState(() => isGenerating = true);

    try {
      final filePath = await PdfGenerator.saveInvoice(widget.billingHistory);
      lastSavedPath = filePath;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invoice saved at: $filePath')),
        );
      }
      debugPrint('[PDF] Invoice saved to: $filePath');
    } catch (e) {
      debugPrint('[PDF][ERROR] Error saving invoice: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving invoice: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isGenerating = false);
    }
  }

  Future<void> _openInvoice() async {
    if (lastSavedPath != null) {
      await OpenFilex.open(lastSavedPath!);
    }
  }
}