class NotificationModel {
  int _notificationId = 0;
  int _receiverId = 0;
  String _notiMsg = "";

  NotificationModel.fromJson(Map json) {
    _notificationId = json['notificationid'] ?? 0;
    _receiverId = json['userid'] ?? 0;
    _notiMsg = json['notificationtxt'] ?? "";
  }

  int getNotificationId() => _notificationId;
  int getReceiverId() => _receiverId;
  String getNotificationMsg() => _notiMsg;
}
