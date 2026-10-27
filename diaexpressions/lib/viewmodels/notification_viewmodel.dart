import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  Set<String> _readNotificationIds = {};
  Set<String> get readNotificationIds => _readNotificationIds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  NotificationViewModel() {
    loadReadNotifications();
  }

  Future<void> loadReadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ids = prefs.getStringList('read_notification_ids');
    if (ids != null) {
      _readNotificationIds = ids.toSet();
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (_readNotificationIds.contains(notificationId)) return;
    _readNotificationIds.add(notificationId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('read_notification_ids', _readNotificationIds.toList());
    notifyListeners();
  }

  int get notificationCount {
    return _notifications.where((item) => isNotificationUnread(item)).length;
  }

  bool isNotificationUnread(NotificationItem item) {
    return item.isRead == '0' && !_readNotificationIds.contains(item.notificationId);
  }

  Future<void> fetchNotifications(String userId) async {
    if (userId.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getNotifications(userId);
      _notifications = response.data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearNotifications() async {
    _notifications = [];
    _readNotificationIds = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('read_notification_ids');
    _errorMessage = null;
    notifyListeners();
  }
}
