import 'package:flutter/material.dart';
import 'package:gstsync/config/app_theme.dart';

/// Invoice Payment Status Model
enum InvoicePaymentStatus {
  unpaid,
  partiallyPaid,
  paid,
  overdue,
}

extension InvoicePaymentStatusExtension on InvoicePaymentStatus {
  String get displayName {
    switch (this) {
      case InvoicePaymentStatus.unpaid:
        return 'Unpaid';
      case InvoicePaymentStatus.partiallyPaid:
        return 'Partial';
      case InvoicePaymentStatus.paid:
        return 'Paid';
      case InvoicePaymentStatus.overdue:
        return 'Overdue';
    }
  }

  Color get color {
    switch (this) {
      case InvoicePaymentStatus.unpaid:
        return Colors.orange;
      case InvoicePaymentStatus.partiallyPaid:
        return Colors.blue;
      case InvoicePaymentStatus.paid:
        return AppTheme.successColor;
      case InvoicePaymentStatus.overdue:
        return AppTheme.errorColor;
    }
  }

  IconData get icon {
    switch (this) {
      case InvoicePaymentStatus.unpaid:
        return Icons.pending_outlined;
      case InvoicePaymentStatus.partiallyPaid:
        return Icons.pie_chart_outline;
      case InvoicePaymentStatus.paid:
        return Icons.check_circle_outline;
      case InvoicePaymentStatus.overdue:
        return Icons.error_outline;
    }
  }
}

/// Payment Status Badge Widget
class PaymentStatusBadge extends StatelessWidget {
  final InvoicePaymentStatus status;
  final bool compact;

  const PaymentStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: compact ? 12 : 14, color: status.color),
          SizedBox(width: compact ? 4 : 6),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Payment Recording Dialog
class PaymentRecordingDialog extends StatefulWidget {
  final double totalAmount;
  final double? paidAmount;
  final Function(double amount, String? notes, DateTime date) onPaymentRecorded;

  const PaymentRecordingDialog({
    super.key,
    required this.totalAmount,
    this.paidAmount,
    required this.onPaymentRecorded,
  });

  @override
  State<PaymentRecordingDialog> createState() => _PaymentRecordingDialogState();
}

class _PaymentRecordingDialogState extends State<PaymentRecordingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _paymentDate = DateTime.now();

  double get _remainingAmount => widget.totalAmount - (widget.paidAmount ?? 0);

  @override
  void initState() {
    super.initState();
    _amountController.text = _remainingAmount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.payment, color: AppTheme.successColor),
          ),
          const SizedBox(width: 12),
          const Text('Record Payment'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Row
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem('Total', '₹${widget.totalAmount.toStringAsFixed(2)}'),
                    _buildSummaryItem('Paid', '₹${(widget.paidAmount ?? 0).toStringAsFixed(2)}'),
                    _buildSummaryItem('Due', '₹${_remainingAmount.toStringAsFixed(2)}',
                        color: AppTheme.errorColor),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Amount Input
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Payment Amount',
                  prefixText: '₹ ',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: TextButton(
                    onPressed: () {
                      _amountController.text = _remainingAmount.toStringAsFixed(2);
                    },
                    child: const Text('Full Amount'),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter payment amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Enter valid amount';
                  }
                  if (amount > _remainingAmount) {
                    return 'Cannot exceed due amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _paymentDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _paymentDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[600]),
                      const SizedBox(width: 12),
                      Text(
                        '${_paymentDate.day}/${_paymentDate.month}/${_paymentDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'e.g., Payment via UPI',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final amount = double.parse(_amountController.text);
              widget.onPaymentRecorded(
                amount,
                _notesController.text.isNotEmpty ? _notesController.text : null,
                _paymentDate,
              );
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.check, size: 18),
          label: const Text('Record Payment'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.successColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

/// Payment History Item Widget
class PaymentHistoryItem extends StatelessWidget {
  final double amount;
  final DateTime date;
  final String? notes;

  const PaymentHistoryItem({
    super.key,
    required this.amount,
    required this.date,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.successColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.payment, color: AppTheme.successColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (notes != null)
                  Text(
                    notes!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
