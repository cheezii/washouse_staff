import 'notification.dart';

class NotificationResponse {
  int? numOfUnread;
  List<NotificationItem>? notifications;

  NotificationResponse({this.numOfUnread, this.notifications});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    numOfUnread = json['numOfUnread'];
    if (json['notifications'] != null) {
      notifications = <NotificationItem>[];
      json['notifications'].forEach((v) {
        notifications!.add(new NotificationItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numOfUnread'] = this.numOfUnread;
    if (this.notifications != null) {
      data['notifications'] = this.notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
