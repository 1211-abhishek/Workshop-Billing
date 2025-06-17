import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import '../models/billing_history.dart';
import '../services/pdf_generator.dart';
import '../responsive_layout.dart';
import '../widgets/bill_widget_preview.dart';

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

  Uint8List? _cachedPdfBytes;
  bool _isPdfGeneratingInBackground = false;

  @override
  void initState() {
    super.initState();
    _startBackgroundPdfGeneration();
  }

  void _startBackgroundPdfGeneration() async {
    setState(() => _isPdfGeneratingInBackground = true);
    try {
      final pdfBytes = await compute(_generatePdfInIsolate, {
        'billingHistory': widget.billingHistory,
        'format': PdfPageFormat.a4,
      });
      if (mounted) {
        setState(() {
          _cachedPdfBytes = pdfBytes;
          _isPdfGeneratingInBackground = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPdfGeneratingInBackground = false);
      }
    }
  }

  static Future<Uint8List> _generatePdfInIsolate(Map<String, dynamic> args) async {
    final BillingHistory billingHistory = args['billingHistory'];
    final PdfPageFormat format = args['format'];
    return await PdfGenerator.generateInvoice(billingHistory, format);
  }

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
          if (isGenerating || _isPdfGeneratingInBackground) ...[
            Expanded(
              child: BillWidgetPreview(billingHistory: widget.billingHistory),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ] else ...[
            Expanded(
              child: PdfPreview(
                build: (format) async {
                  if (_cachedPdfBytes != null) return _cachedPdfBytes!;
                  return await PdfGenerator.generateInvoice(widget.billingHistory, format);
                },
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

  Future<void> _shareInvoice() async {
    debugPrint('[PDF] _shareInvoice called');
    setState(() => isGenerating = true);

    try {
      final pdfBytes = _cachedPdfBytes ?? await PdfGenerator.generateInvoice(
        widget.billingHistory,
        PdfPageFormat.a4,
      );
      if (kIsWeb) {
        await Printing.sharePdf(
          bytes: pdfBytes,
          filename: 'Invoice-${widget.billingHistory.invoiceNumber}.pdf',
        );
      } else {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/invoice_${widget.billingHistory.invoiceNumber}.pdf');
        await file.writeAsBytes(pdfBytes);
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Invoice ${widget.billingHistory.invoiceNumber}',
        );
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
      final pdfBytes = _cachedPdfBytes ?? await PdfGenerator.generateInvoice(
        widget.billingHistory,
        PdfPageFormat.a4,
      );
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/invoice_${widget.billingHistory.invoiceNumber}.pdf');
      await file.writeAsBytes(pdfBytes);
      lastSavedPath = file.path;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invoice saved at: ${file.path}')),
        );
      }
      debugPrint('[PDF] Invoice saved to: ${file.path}');
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