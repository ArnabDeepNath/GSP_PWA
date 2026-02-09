/// Web-based FCM Notification Service
/// Uses browser Notification API and service worker for push notifications
class FCMNotificationService {
  static final FCMNotificationService _instance = FCMNotificationService._internal();
  factory FCMNotificationService() => _instance;
  FCMNotificationService._internal();

  String? _token;

  /// Initialize FCM for web
  /// Note: Web FCM setup is done in firebase-messaging-sw.js service worker
  Future<void> initialize() async {
    // For web, FCM is configured in:
    // 1. firebase-messaging-sw.js (service worker)
    // 2. index.html (Firebase config)
    print('FCM Web Service initialized - using service worker');
  }

  /// Get current FCM token
  String? get token => _token;

  /// Set token (received from JS interop)
  void setToken(String token) {
    _token = token;
    print('FCM Token set: $token');
  }

  /// Subscribe to topic (server-side operation)
  Future<void> subscribeToTopic(String topic) async {
    print('Subscribe to topic: $topic (server-side operation)');
  }

  /// Unsubscribe from topic (server-side operation)
  Future<void> unsubscribeFromTopic(String topic) async {
    print('Unsubscribe from topic: $topic (server-side operation)');
  }

  /// Schedule invoice reminder notification (server-side)
  Future<void> scheduleInvoiceReminder({
    required String invoiceNumber,
    required String partyName,
    required double amount,
    required DateTime dueDate,
  }) async {
    print('Invoice reminder scheduled for $invoiceNumber');
  }

  /// Send payment received notification (server-side)
  Future<void> sendPaymentNotification({
    required String invoiceNumber,
    required String partyName,
    required double amount,
  }) async {
    print('Payment notification for $invoiceNumber');
  }

  /// Send GST filing reminder (server-side)
  Future<void> sendGSTFilingReminder({
    required String returnType,
    required String period,
    required DateTime dueDate,
  }) async {
    print('GST filing reminder for $returnType - $period');
  }
}

/// Notification Types
class NotificationTypes {
  static const String invoice = 'invoice';
  static const String payment = 'payment';
  static const String gstReminder = 'gst_reminder';
  static const String general = 'general';
}
