import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:intl/intl.dart';
import '../models/billing_history.dart';

class PdfGenerator {
  static const String companyName = 'SHIVAM BOSCH PUMP SERVICE';
  static const String companySubtitle = '(Bosch Pump Service Center)';
  static const String companyAddress = 'Tembhurni Bypass Road, Mahadeonagar,\nAKLUJ-413101 Tel.Malshiras,Dist.Solapur Mob. 9960074484';

  static Future<Uint8List> generateInvoice(
    BillingHistory billingHistory,
    PdfPageFormat format,
  ) async {
    try {
      print('[PDF] generateInvoice called');
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.nunitoRegular();
      final boldFont = await PdfGoogleFonts.nunitoBold();

      pdf.addPage(
        pw.Page(
          pageFormat: format,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            print('[PDF] Building PDF page');
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(boldFont, font),
                pw.SizedBox(height: 20),
                
                // Invoice Info and Customer Details
                _buildInvoiceInfo(billingHistory, font, boldFont),
                pw.SizedBox(height: 20),
                
                // Items Table
                _buildItemsTable(billingHistory, font, boldFont),
                pw.SizedBox(height: 20),
                
                // Summary
                _buildSummary(billingHistory, font, boldFont),
                
                pw.Spacer(),
                
                // Footer
                _buildFooter(font),
              ],
            );
          },
        ),
      );

      print('[PDF] PDF generated successfully in generate invoice method');
      return pdf.save();
    } catch (e, stack) {
      print('[PDF][ERROR] Error generating PDF: $e\n$stack');
      rethrow;
    }
  }

  static pw.Widget _buildHeader(pw.Font boldFont, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 2),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  companyName,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  companySubtitle,
                  style: pw.TextStyle(font: font, fontSize: 12),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  companyAddress,
                  style: pw.TextStyle(font: font, fontSize: 10),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInvoiceInfo(
    BillingHistory billingHistory,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Customer Details
        pw.Expanded(
          flex: 2,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('CUSTOMER DETAILS', style: pw.TextStyle(font: boldFont, fontSize: 12)),
                pw.SizedBox(height: 8),
                pw.Text('Name: ${billingHistory.customerName ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                pw.SizedBox(height: 4),
                pw.Text('Contact: ${billingHistory.customerContact ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                pw.SizedBox(height: 4),
                pw.Text('Address: ${billingHistory.customerAddress ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                pw.SizedBox(height: 8),
                pw.Text('MACHINE INFO', style: pw.TextStyle(font: boldFont, fontSize: 12)),
                pw.SizedBox(height: 4),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Engine Type: ${billingHistory.engineType ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                          pw.Text('Pump: ${billingHistory.pump ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                          pw.Text('Governor: ${billingHistory.governor ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                          pw.Text('Feed Pump: ${billingHistory.feedPump ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                          pw.Text('Noozel Holder: ${billingHistory.noozelHolder ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Vehicle No: ${billingHistory.vehicleNumber ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                          pw.Text('Mechanic: ${billingHistory.mechanicName ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                          pw.Text('Arrived: ${billingHistory.arrivedDate != null ? DateFormat('dd/MM/yyyy').format(billingHistory.arrivedDate!) : '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                          pw.Text('Delivered: ${billingHistory.deliveredDate != null ? DateFormat('dd/MM/yyyy').format(billingHistory.deliveredDate!) : '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                          pw.Text('Billing Date: ${billingHistory.billingDate != null ? DateFormat('dd/MM/yyyy').format(billingHistory.billingDate!) : '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 10),
        // Invoice Details
        pw.Expanded(
          flex: 1,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'INVOICE DETAILS',
                  style: pw.TextStyle(font: boldFont, fontSize: 12),
                ),                          
                pw.SizedBox(height: 8),
                
                pw.Text('Serial No: ${billingHistory.serialNumber ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),

                pw.SizedBox(height: 8),
                pw.Text(
                  'Invoice No: ${billingHistory.invoiceNumber}',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Date: ${DateFormat('dd/MM/yyyy').format(billingHistory.date)}',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Time: ${DateFormat('hh:mm a').format(billingHistory.date)}',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildItemsTable(
    BillingHistory billingHistory,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FixedColumnWidth(40),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FixedColumnWidth(60),
        3: const pw.FixedColumnWidth(80),
        4: const pw.FixedColumnWidth(80),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('S.No.', boldFont, isHeader: true),
            _buildTableCell('PART NAME', boldFont, isHeader: true),
            _buildTableCell('QTY', boldFont, isHeader: true),
            _buildTableCell('RATE', boldFont, isHeader: true),
            _buildTableCell('TOTAL', boldFont, isHeader: true),
          ],
        ),
        // Items
        ...billingHistory.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return pw.TableRow(
            children: [
              _buildTableCell('${index + 1}', font),
              _buildTableCell(item.productName, font),
              _buildTableCell('${item.quantity} ${item.unit ?? ''}', font),
              _buildTableCell('₹${item.unitPrice.toStringAsFixed(2)}', font),
              _buildTableCell('₹${item.totalPrice.toStringAsFixed(2)}', font),
            ],
          );
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, pw.Font font, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildSummary(
    BillingHistory billingHistory,
    pw.Font font,
    pw.Font boldFont,
  ) {
    final subtotal = billingHistory.items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final pumpLabour = billingHistory.pumpLabourCharge ?? 0.0;
    final nozzleLabour = billingHistory.nozzleLabourCharge ?? 0.0;
    final otherCharges = billingHistory.otherCharges ?? 0.0;
    final discount = billingHistory.discountAmount;
    final tax = billingHistory.taxAmount;
    final grandTotal = subtotal - discount + tax + pumpLabour + nozzleLabour + otherCharges;

    return pw.Row(
      children: [
        pw.Expanded(child: pw.Container()),
        pw.Container(
          width: 200,
          child: pw.Column(
            children: [
              _buildSummaryRow('Subtotal:', '₹${subtotal.toStringAsFixed(2)}', font),
              if (discount > 0)
                _buildSummaryRow('Discount:', '-₹${discount.toStringAsFixed(2)}', font),
              if (tax > 0)
                _buildSummaryRow('Tax:', '₹${tax.toStringAsFixed(2)}', font),
              if (pumpLabour > 0)
                _buildSummaryRow('Labour (Pump):', '₹${pumpLabour.toStringAsFixed(2)}', font),
              if (nozzleLabour > 0)
                _buildSummaryRow('Labour (Nozzle):', '₹${nozzleLabour.toStringAsFixed(2)}', font),
              if (otherCharges > 0)
                _buildSummaryRow('Other Charges:', '₹${otherCharges.toStringAsFixed(2)}', font),
              pw.Divider(),
              _buildSummaryRow('GRAND TOTAL:', '₹${grandTotal.toStringAsFixed(2)}', boldFont, isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryRow(String label, String value, pw.Font font, {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              font: font,
              fontSize: isTotal ? 12 : 10,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: font,
              fontSize: isTotal ? 12 : 10,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Font font) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('DELIVERED', style: pw.TextStyle(font: font, fontSize: 10)),
                pw.SizedBox(height: 20),
                pw.Text('DATE: ___________', style: pw.TextStyle(font: font, fontSize: 10)),
                pw.SizedBox(height: 10),
                pw.Text('SIGN: ___________', style: pw.TextStyle(font: font, fontSize: 10)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('CUSTOMER\'S SIGN', style: pw.TextStyle(font: font, fontSize: 10)),
                pw.SizedBox(height: 40),
                pw.Text('For: $companyName', style: pw.TextStyle(font: font, fontSize: 10)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Future<void> shareInvoice(BillingHistory billingHistory) async {
    try {
      print('[PDF] shareInvoice called');
      final pdfBytes = await generateInvoice(billingHistory, PdfPageFormat.a4);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/invoice_${billingHistory.invoiceNumber}.pdf');
      await file.writeAsBytes(pdfBytes);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Invoice ${billingHistory.invoiceNumber}',
      );
      print('[PDF] Invoice shared successfully');
    } catch (e, stack) {
      print('[PDF][ERROR] Failed to share invoice: $e\n$stack');
      throw Exception('Failed to share invoice: $e');
    }
  }

  static Future<String> saveInvoice(BillingHistory billingHistory) async {
    try {
      print('[PDF] saveInvoice called');
      final pdfBytes = await generateInvoice(billingHistory, PdfPageFormat.a4);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/invoice_${billingHistory.invoiceNumber}.pdf');
      await file.writeAsBytes(pdfBytes);
      print('[PDF] Invoice saved at ${file.path}');
      return file.path;
    } catch (e, stack) {
      print('[PDF][ERROR] Failed to save invoice: $e\n$stack');
      throw Exception('Failed to save invoice: $e');
    }
  }
}
