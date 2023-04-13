class Order {
  String? orderId;
  String? orderDate;
  String? customerName;
  int? totalOrderValue;
  int? discount;
  int? totalOrderPayment;
  String? status;
  List<OrderedServices>? orderedServices;

  Order(
      {this.orderId,
      this.orderDate,
      this.customerName,
      this.totalOrderValue,
      this.discount,
      this.totalOrderPayment,
      this.status,
      this.orderedServices});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderDate = json['orderDate'];
    customerName = json['customerName'];
    totalOrderValue = json['totalOrderValue'];
    discount = json['discount'];
    totalOrderPayment = json['totalOrderPayment'];
    status = json['status'];
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
    if (this.orderedServices != null) {
      data['orderedServices'] =
          this.orderedServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderedServices {
  String? serviceName;
  String? serviceCategory;
  double? measurement;
  String? unit;
  String? image;
  int? price;

  OrderedServices(
      {this.serviceName,
      this.serviceCategory,
      this.measurement,
      this.unit,
      this.image,
      this.price});

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
