class NotificationPush {
  String body;
  String createdAt;
  Data data;
  String idNotification;
  dynamic imgUrl;
  bool isDeleted;
  bool isRead;
  String notificationType;
  dynamic readAt;
  String sentAt;
  String status;
  String title;
  String updatedAt;
  String userId;

  NotificationPush({
    required this.body,
    required this.createdAt,
    required this.data,
    required this.idNotification,
    required this.imgUrl,
    required this.isDeleted,
    required this.isRead,
    required this.notificationType,
    required this.readAt,
    required this.sentAt,
    required this.status,
    required this.title,
    required this.updatedAt,
    required this.userId,
  });

  factory NotificationPush.fromJson(Map<String, dynamic> json) =>
      NotificationPush(
        body: json["body"],
        createdAt: json["created_at"],
        data: Data.fromJson(json["data"]),
        idNotification: json["id_notification"],
        imgUrl: json["img_url"],
        isDeleted: json["is_deleted"],
        isRead: json["is_read"],
        notificationType: json["notification_type"],
        readAt: json["read_at"],
        sentAt: json["sent_at"],
        status: json["status"],
        title: json["title"],
        updatedAt: json["updated_at"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
    "body": body,
    "created_at": createdAt,
    "data": data.toJson(),
    "id_notification": idNotification,
    "img_url": imgUrl,
    "is_deleted": isDeleted,
    "is_read": isRead,
    "notification_type": notificationType,
    "read_at": readAt,
    "sent_at": sentAt,
    "status": status,
    "title": title,
    "updated_at": updatedAt,
    "user_id": userId,
  };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
