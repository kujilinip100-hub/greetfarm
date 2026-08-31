class NotificationModel {
  final int notificationId;
  final String message;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    required this.notificationId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: int.parse(json["notification_id"].toString()),
      message: json["message"],
      isRead: json["is_read"].toString() == "1",
      createdAt: json["created_at"],
    );
  }
}