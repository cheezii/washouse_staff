class OrderTracking {
  String? status;
  String? createdDate;
  String? updatedDate;

  OrderTracking({this.status, this.createdDate, this.updatedDate});

  OrderTracking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
