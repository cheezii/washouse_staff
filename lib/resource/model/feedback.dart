class FeedbackModel {
  int? id;
  String? content;
  int? rating;
  String? orderId;
  int? centerId;
  String? centerName;
  int? serviceId;
  String? serviceName;
  String? createdBy;
  String? createdDate;
  String? replyMessage;
  String? replyBy;
  String? replyDate;
  String? accountName;
  String? accountAvatar;

  FeedbackModel(
      {this.id,
      this.content,
      this.rating,
      this.orderId,
      this.centerId,
      this.centerName,
      this.serviceId,
      this.serviceName,
      this.createdBy,
      this.createdDate,
      this.replyMessage,
      this.replyBy,
      this.replyDate,
      this.accountName,
      this.accountAvatar});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    rating = json['rating'];
    orderId = json['orderId'];
    centerId = json['centerId'];
    centerName = json['centerName'];
    serviceId = json['serviceId'];
    serviceName = json['serviceName'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    replyMessage = json['replyMessage'];
    replyBy = json['replyBy'];
    replyDate = json['replyDate'];
    accountName = json['accountName'];
    accountAvatar = json['accountAvatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['rating'] = this.rating;
    data['orderId'] = this.orderId;
    data['centerId'] = this.centerId;
    data['centerName'] = this.centerName;
    data['serviceId'] = this.serviceId;
    data['serviceName'] = this.serviceName;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['replyMessage'] = this.replyMessage;
    data['replyBy'] = this.replyBy;
    data['replyDate'] = this.replyDate;
    data['accountName'] = this.accountName;
    data['accountAvatar'] = this.accountAvatar;
    return data;
  }
}
