class NotificationItem {
  final String notificationId;
  final String userId;
  final String? designId;
  final String title;
  final String message;
  final String notificationType;
  final String isRead; // "0" or "1"
  final String createDate;

  NotificationItem({
    required this.notificationId,
    required this.userId,
    this.designId,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.isRead,
    required this.createDate,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notification_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      designId: json['design_id']?.toString(),
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      notificationType: json['notification_type']?.toString() ?? '',
      isRead: json['is_read']?.toString() ?? '0',
      createDate: json['create_date']?.toString() ?? '',
    );
  }
}

class NotificationResponse {
  final int status;
  final String message;
  final int notificationCount;
  final List<NotificationItem> data;

  NotificationResponse({
    required this.status,
    required this.message,
    required this.notificationCount,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List?)
            ?.map((e) => NotificationItem.fromJson(e))
            .toList() ??
        [];
    return NotificationResponse(
      status: json['status'] is int ? json['status'] : (int.tryParse(json['status']?.toString() ?? '0') ?? 0),
      message: json['message']?.toString() ?? '',
      notificationCount: json['notification_count'] is int 
          ? json['notification_count'] 
          : (int.tryParse(json['notification_count']?.toString() ?? '0') ?? 0),
      data: list,
    );
  }
}
