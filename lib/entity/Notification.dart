class NotificationModel {
  final int id;
  final String recipientType;
  final String recipientId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.recipientType,
    required this.recipientId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      recipientType: json['recipient_type'],
      recipientId: json['recipient_id'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
