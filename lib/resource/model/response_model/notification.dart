class NotificationItem {
  int? id;
  String? title;
  String? content;
  String? orderId;
  int? accountId;
  String? createdDate;
  bool? isRead;

  NotificationItem({this.id, this.title, this.content, this.orderId, this.accountId, this.createdDate, this.isRead});

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    orderId = json['orderId'];
    accountId = json['accountId'];
    createdDate = json['createdDate'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['orderId'] = this.orderId;
    data['accountId'] = this.accountId;
    data['createdDate'] = this.createdDate;
    data['isRead'] = this.isRead;
    return data;
  }
}
