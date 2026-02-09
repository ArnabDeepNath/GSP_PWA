import 'dart:convert';
import 'package:http/http.dart' as http;

/// WhatsApp Business API Integration Service
/// Handles sending messages, invoice reminders, and payment notifications
class WhatsAppService {
  static const String _apiUrl = 'https://graph.facebook.com/v17.0';
  
  final String phoneNumberId;
  final String accessToken;

  WhatsAppService({
    required this.phoneNumberId,
    required this.accessToken,
  });

  /// Send a text message via WhatsApp
  Future<WhatsAppResult> sendTextMessage({
    required String to,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/$phoneNumberId/messages'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'messaging_product': 'whatsapp',
          'to': _formatPhoneNumber(to),
          'type': 'text',
          'text': {'body': message},
        }),
      );

      if (response.statusCode == 200) {
        return WhatsAppResult.success('Message sent successfully');
      } else {
        return WhatsAppResult.error('Failed: ${response.body}');
      }
    } catch (e) {
      return WhatsAppResult.error('Error: $e');
    }
  }

  /// Send invoice reminder using template
  Future<WhatsAppResult> sendInvoiceReminder({
    required String to,
    required String customerName,
    required String invoiceNumber,
    required String amount,
    required String dueDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/$phoneNumberId/messages'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'messaging_product': 'whatsapp',
          'to': _formatPhoneNumber(to),
          'type': 'template',
          'template': {
            'name': 'invoice_reminder',
            'language': {'code': 'en'},
            'components': [
              {
                'type': 'body',
                'parameters': [
                  {'type': 'text', 'text': customerName},
                  {'type': 'text', 'text': invoiceNumber},
                  {'type': 'text', 'text': amount},
                  {'type': 'text', 'text': dueDate},
                ],
              },
            ],
          },
        }),
      );

      if (response.statusCode == 200) {
        return WhatsAppResult.success('Invoice reminder sent');
      } else {
        return WhatsAppResult.error('Failed: ${response.body}');
      }
    } catch (e) {
      return WhatsAppResult.error('Error: $e');
    }
  }

  /// Send payment confirmation
  Future<WhatsAppResult> sendPaymentConfirmation({
    required String to,
    required String customerName,
    required String invoiceNumber,
    required String amount,
    required String paymentDate,
  }) async {
    try {
      final message = '''
🎉 *Payment Received*

Dear $customerName,

Thank you for your payment!

📄 Invoice: $invoiceNumber
💰 Amount: ₹$amount
📅 Date: $paymentDate

Your payment has been successfully recorded.

Best regards,
GSTSync Team
''';

      return await sendTextMessage(to: to, message: message);
    } catch (e) {
      return WhatsAppResult.error('Error: $e');
    }
  }

  /// Send GST filing reminder
  Future<WhatsAppResult> sendGSTFilingReminder({
    required String to,
    required String returnType,
    required String dueDate,
    required String period,
  }) async {
    final message = '''
⚠️ *GST Filing Reminder*

Your $returnType return for $period is due on $dueDate.

Please ensure you file before the deadline to avoid late fees.

📊 Quick Actions:
• View pending invoices
• Generate reports
• File returns

Open GSTSync to proceed.
''';

    return await sendTextMessage(to: to, message: message);
  }

  /// Format phone number to WhatsApp format
  String _formatPhoneNumber(String phone) {
    // Remove spaces, dashes, and other characters
    String cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Add country code if not present
    if (!cleaned.startsWith('+')) {
      if (cleaned.startsWith('0')) {
        cleaned = '+91${cleaned.substring(1)}';
      } else {
        cleaned = '+91$cleaned';
      }
    }

    return cleaned.replaceAll('+', '');
  }
}

/// WhatsApp API Result
class WhatsAppResult {
  final bool isSuccess;
  final String message;
  final String? messageId;

  WhatsAppResult._({
    required this.isSuccess,
    required this.message,
    this.messageId,
  });

  factory WhatsAppResult.success(String message, {String? messageId}) {
    return WhatsAppResult._(
      isSuccess: true,
      message: message,
      messageId: messageId,
    );
  }

  factory WhatsAppResult.error(String message) {
    return WhatsAppResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// WhatsApp Configuration Helper
class WhatsAppConfig {
  static const String templateInvoiceReminder = 'invoice_reminder';
  static const String templatePaymentConfirmation = 'payment_confirmation';
  static const String templateGSTReminder = 'gst_filing_reminder';

  /// Get configured WhatsApp service from environment
  static WhatsAppService? fromEnvironment() {
    const phoneNumberId = String.fromEnvironment('WHATSAPP_PHONE_ID', defaultValue: '');
    const accessToken = String.fromEnvironment('WHATSAPP_ACCESS_TOKEN', defaultValue: '');

    if (phoneNumberId.isEmpty || accessToken.isEmpty) {
      return null;
    }

    return WhatsAppService(
      phoneNumberId: phoneNumberId,
      accessToken: accessToken,
    );
  }
}
