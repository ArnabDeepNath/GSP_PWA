import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:gstsync/features/invoice/domain/models/invoice.dart';
import 'package:gstsync/features/party/domain/models/party.dart';
import 'package:intl/intl.dart';

/// Excel Export Service for generating and downloading Excel files
class ExcelExportService {
  /// Export invoices to Excel/CSV format
  static Future<void> exportInvoices(
    List<Invoice> invoices,
    List<Party> parties, {
    String? filename,
  }) async {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final buffer = StringBuffer();

    // Header row
    buffer.writeln([
      'Invoice Number',
      'Date',
      'Party Name',
      'GSTIN',
      'Type',
      'Subtotal',
      'Tax Amount',
      'Total Amount',
      'Status',
      'Notes',
    ].join(','));

    // Data rows
    for (final invoice in invoices) {
      final party = parties.firstWhere(
        (p) => p.id == invoice.partyId,
        orElse: () => Party(
          id: '',
          name: 'Unknown',
          type: PartyType.buyer,
          storeId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      buffer.writeln([
        _escapeCSV(invoice.invoiceNumber),
        dateFormat.format(invoice.invoiceDate),
        _escapeCSV(party.name),
        _escapeCSV(party.gstin ?? ''),
        invoice.documentType.toString().split('.').last,
        invoice.subtotal.toStringAsFixed(2),
        invoice.taxAmount.toStringAsFixed(2),
        invoice.totalAmount.toStringAsFixed(2),
        invoice.isPaid ? 'Paid' : 'Unpaid',
        _escapeCSV(invoice.notes ?? ''),
      ].join(','));
    }

    _downloadFile(
      buffer.toString(),
      filename ?? 'invoices_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
      'text/csv',
    );
  }

  /// Export parties to Excel/CSV format
  static Future<void> exportParties(List<Party> parties, {String? filename}) async {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final buffer = StringBuffer();

    // Header row
    buffer.writeln([
      'Name',
      'Type',
      'GSTIN',
      'Phone',
      'Email',
      'Address',
      'City',
      'State',
      'Pincode',
      'Created Date',
    ].join(','));

    // Data rows
    for (final party in parties) {
      buffer.writeln([
        _escapeCSV(party.name),
        party.type == PartyType.buyer ? 'Customer' : 'Supplier',
        _escapeCSV(party.gstin ?? ''),
        _escapeCSV(party.phone ?? ''),
        _escapeCSV(party.email ?? ''),
        _escapeCSV(party.address ?? ''),
        _escapeCSV(party.city ?? ''),
        _escapeCSV(party.state ?? ''),
        _escapeCSV(party.pincode ?? ''),
        dateFormat.format(party.createdAt),
      ].join(','));
    }

    _downloadFile(
      buffer.toString(),
      filename ?? 'parties_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
      'text/csv',
    );
  }

  /// Export GST report summary to Excel/CSV format
  static Future<void> exportGSTReport({
    required DateTime startDate,
    required DateTime endDate,
    required double totalSales,
    required double totalPurchases,
    required double totalOutputTax,
    required double totalInputTax,
    required double netTaxLiability,
    required List<Map<String, dynamic>> invoiceBreakdown,
    String? filename,
  }) async {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final buffer = StringBuffer();

    // Summary Section
    buffer.writeln('GST Summary Report');
    buffer.writeln('Period: ${dateFormat.format(startDate)} to ${dateFormat.format(endDate)}');
    buffer.writeln('');
    buffer.writeln('Summary');
    buffer.writeln('Total Sales,${totalSales.toStringAsFixed(2)}');
    buffer.writeln('Total Purchases,${totalPurchases.toStringAsFixed(2)}');
    buffer.writeln('Output Tax (Collected),${totalOutputTax.toStringAsFixed(2)}');
    buffer.writeln('Input Tax (Paid),${totalInputTax.toStringAsFixed(2)}');
    buffer.writeln('Net Tax Liability,${netTaxLiability.toStringAsFixed(2)}');
    buffer.writeln('');

    // Invoice Breakdown Section
    buffer.writeln('Invoice Breakdown');
    buffer.writeln([
      'Invoice #',
      'Date',
      'Type',
      'Taxable Value',
      'CGST',
      'SGST',
      'IGST',
      'Total',
    ].join(','));

    for (final inv in invoiceBreakdown) {
      buffer.writeln([
        _escapeCSV(inv['invoiceNumber'] ?? ''),
        inv['date'] ?? '',
        inv['type'] ?? '',
        (inv['taxableValue'] ?? 0).toStringAsFixed(2),
        (inv['cgst'] ?? 0).toStringAsFixed(2),
        (inv['sgst'] ?? 0).toStringAsFixed(2),
        (inv['igst'] ?? 0).toStringAsFixed(2),
        (inv['total'] ?? 0).toStringAsFixed(2),
      ].join(','));
    }

    _downloadFile(
      buffer.toString(),
      filename ?? 'gst_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
      'text/csv',
    );
  }

  /// Helper to escape CSV values
  static String _escapeCSV(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Download file in browser
  static void _downloadFile(String content, String filename, String mimeType) {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..style.display = 'none';
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    }
  }
}

/// Export Button Widget
class ExportButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  const ExportButton({
    super.key,
    required this.onPressed,
    this.label = 'Export',
    this.icon = Icons.download,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
