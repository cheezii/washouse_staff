class Order {
  String? orderId;
  String? orderDate;
  String? customerName;
  num? totalOrderValue;
  num? discount;
  num? totalOrderPayment;
  String? status;
  int? deliveryType;
  int? centerId;
  String? centerName;
  List<Deliveries>? deliveries;
  List<OrderedServices>? orderedServices;

  Order(
      {this.orderId,
      this.orderDate,
      this.customerName,
      this.totalOrderValue,
      this.discount,
      this.totalOrderPayment,
      this.status,
      this.deliveryType,
      this.centerId,
      this.centerName,
      this.deliveries,
      this.orderedServices});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderDate = json['orderDate'];
    customerName = json['customerName'];
    totalOrderValue = json['totalOrderValue'];
    discount = json['discount'];
    totalOrderPayment = json['totalOrderPayment'];
    status = json['status'];
    deliveryType = json['deliveryType'];
    centerId = json['centerId'];
    centerName = json['centerName'];
    if (json['deliveries'] != null) {
      deliveries = <Deliveries>[];
      json['deliveries'].forEach((v) {
        deliveries!.add(new Deliveries.fromJson(v));
      });
    }
    if (json['orderedServices'] != null) {
      orderedServices = <OrderedServices>[];
      json['orderedServices'].forEach((v) {
        orderedServices!.add(new OrderedServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderDate'] = this.orderDate;
    data['customerName'] = this.customerName;
    data['totalOrderValue'] = this.totalOrderValue;
    data['discount'] = this.discount;
    data['totalOrderPayment'] = this.totalOrderPayment;
    data['status'] = this.status;
    data['deliveryType'] = this.deliveryType;
    data['centerId'] = this.centerId;
    data['centerName'] = this.centerName;
    if (this.deliveries != null) {
      data['deliveries'] = this.deliveries!.map((v) => v.toJson()).toList();
    }
    if (this.orderedServices != null) {
      data['orderedServices'] = this.orderedServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Deliveries {
  String? deliveryStatus;
  String? addressString;
  String? wardName;
  String? districtName;

  Deliveries({this.deliveryStatus, this.addressString, this.wardName, this.districtName});

  Deliveries.fromJson(Map<String, dynamic> json) {
    deliveryStatus = json['deliveryStatus'];
    addressString = json['addressString'];
    wardName = json['wardName'];
    districtName = json['districtName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryStatus'] = this.deliveryStatus;
    data['addressString'] = this.addressString;
    data['wardName'] = this.wardName;
    data['districtName'] = this.districtName;
    return data;
  }
}

class OrderedServices {
  String? serviceName;
  String? serviceCategory;
  double? measurement;
  String? unit;
  String? image;
  double? price;

  OrderedServices({this.serviceName, this.serviceCategory, this.measurement, this.unit, this.image, this.price});

  OrderedServices.fromJson(Map<String, dynamic> json) {
    serviceName = json['serviceName'];
    serviceCategory = json['serviceCategory'];
    measurement = json['measurement'];
    unit = json['unit'];
    image = json['image'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceName'] = this.serviceName;
    data['serviceCategory'] = this.serviceCategory;
    data['measurement'] = this.measurement;
    data['unit'] = this.unit;
    data['image'] = this.image;
    data['price'] = this.price;
    return data;
  }
}
