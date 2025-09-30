import 'package:flutter/material.dart';
import 'package:flutter_billing_system/ui/responsive/bill_preview_screen_desktop.dart';
import 'package:flutter_billing_system/ui/responsive/bill_preview_screen_mobile.dart';
import 'package:flutter_billing_system/ui/responsive/bill_preview_screen_tablet.dart';
import '../models/billing_history.dart';
import 'package:pdf/pdf.dart';
import '../services/pdf_generator.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:responsive_builder/responsive_builder.dart';

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
      final pdfBytes = await PdfGenerator.generateInvoice(
          widget.billingHistory, PdfPageFormat.a4);
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
      final file = File(
          '${directory.path}/invoice_${widget.billingHistory.invoiceNumber}.pdf');
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
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => BillPreviewScreenMobile(
          billingHistory: widget.billingHistory,
          isGenerating: isGenerating,
          pdfBytes: _pdfBytes,
          onPrint: _printPdf,
          onShare: _sharePdf,
        ),
        tablet: (BuildContext context) => BillPreviewScreenTablet(
          billingHistory: widget.billingHistory,
          isGenerating: isGenerating,
          pdfBytes: _pdfBytes,
          onPrint: _printPdf,
          onShare: _sharePdf,
        ),
        desktop: (BuildContext context) => BillPreviewScreenDesktop(
          billingHistory: widget.billingHistory,
          isGenerating: isGenerating,
          pdfBytes: _pdfBytes,
          onPrint: _printPdf,
          onShare: _sharePdf,
        ),
      ),
    );
  }
}
