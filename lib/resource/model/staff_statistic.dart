class Statistic {
  OrderOverview? orderOverview;
  List<Dailystatistics>? dailystatistics;

  Statistic({this.orderOverview, this.dailystatistics});

  Statistic.fromJson(Map<String, dynamic> json) {
    orderOverview = json['orderOverview'] != null ? new OrderOverview.fromJson(json['orderOverview']) : null;
    if (json['dailystatistics'] != null) {
      dailystatistics = <Dailystatistics>[];
      json['dailystatistics'].forEach((v) {
        dailystatistics!.add(new Dailystatistics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderOverview != null) {
      data['orderOverview'] = this.orderOverview!.toJson();
    }
    if (this.dailystatistics != null) {
      data['dailystatistics'] = this.dailystatistics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderOverview {
  int? numOfPendingOrder;
  int? numOfProcessingOrder;
  int? numOfReadyOrder;
  int? numOfPendingDeliveryOrder;
  int? numOfCompletedOrder;
  int? numOfCancelledOrder;

  OrderOverview(
      {this.numOfPendingOrder,
      this.numOfProcessingOrder,
      this.numOfReadyOrder,
      this.numOfPendingDeliveryOrder,
      this.numOfCompletedOrder,
      this.numOfCancelledOrder});

  OrderOverview.fromJson(Map<String, dynamic> json) {
    numOfPendingOrder = json['numOfPendingOrder'];
    numOfProcessingOrder = json['numOfProcessingOrder'];
    numOfReadyOrder = json['numOfReadyOrder'];
    numOfPendingDeliveryOrder = json['numOfPendingDeliveryOrder'];
    numOfCompletedOrder = json['numOfCompletedOrder'];
    numOfCancelledOrder = json['numOfCancelledOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numOfPendingOrder'] = this.numOfPendingOrder;
    data['numOfProcessingOrder'] = this.numOfProcessingOrder;
    data['numOfReadyOrder'] = this.numOfReadyOrder;
    data['numOfPendingDeliveryOrder'] = this.numOfPendingDeliveryOrder;
    data['numOfCompletedOrder'] = this.numOfCompletedOrder;
    data['numOfCancelledOrder'] = this.numOfCancelledOrder;
    return data;
  }
}

class Dailystatistics {
  String? day;
  num? totalOrder;
  int? successfulOrder;
  int? cancelledOrder;
  num? revenue;

  Dailystatistics({this.day, this.totalOrder, this.successfulOrder, this.cancelledOrder, this.revenue});

  Dailystatistics.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    totalOrder = json['totalOrder'];
    successfulOrder = json['successfulOrder'];
    cancelledOrder = json['cancelledOrder'];
    revenue = json['revenue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['totalOrder'] = this.totalOrder;
    data['successfulOrder'] = this.successfulOrder;
    data['cancelledOrder'] = this.cancelledOrder;
    data['revenue'] = this.revenue;
    return data;
  }
}
