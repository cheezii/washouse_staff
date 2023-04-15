class Order_Infomation {
  String? id;
  String? customerName;
  int? locationId;
  String? customerAddress;
  String? customerEmail;
  String? customerMobile;
  String? customerMessage;
  int? customerOrdered;
  num? totalOrderValue;
  int? deliveryType;
  num? deliveryPrice;
  String? preferredDropoffTime;
  String? preferredDeliverTime;
  String? status;
  List<OrderedDetails>? orderedDetails;
  List<OrderDetailTrackings>? orderDetailTrackings;
  List<OrderTrackings>? orderTrackings;
  List<OrderDeliveries>? orderDeliveries;
  OrderPayment? orderPayment;

  Order_Infomation(
      {this.id,
      this.customerName,
      this.locationId,
      this.customerAddress,
      this.customerEmail,
      this.customerMobile,
      this.customerMessage,
      this.customerOrdered,
      this.totalOrderValue,
      this.deliveryType,
      this.deliveryPrice,
      this.preferredDropoffTime,
      this.preferredDeliverTime,
      this.status,
      this.orderedDetails,
      this.orderDetailTrackings,
      this.orderTrackings,
      this.orderDeliveries,
      this.orderPayment});

  Order_Infomation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customerName'];
    locationId = json['locationId'];
    customerAddress = json['customerAddress'];
    customerEmail = json['customerEmail'];
    customerMobile = json['customerMobile'];
    customerMessage = json['customerMessage'];
    customerOrdered = json['customerOrdered'];
    totalOrderValue = json['totalOrderValue'];
    deliveryType = json['deliveryType'];
    deliveryPrice = json['deliveryPrice'];
    preferredDropoffTime = json['preferredDropoffTime'];
    preferredDeliverTime = json['preferredDeliverTime'];
    status = json['status'];
    if (json['orderedDetails'] != null) {
      orderedDetails = <OrderedDetails>[];
      json['orderedDetails'].forEach((v) {
        orderedDetails!.add(new OrderedDetails.fromJson(v));
      });
    }
    if (json['orderDetailTrackings'] != null) {
      orderDetailTrackings = <OrderDetailTrackings>[];
      json['orderDetailTrackings'].forEach((v) {
        orderDetailTrackings!.add(new OrderDetailTrackings.fromJson(v));
      });
    }
    if (json['orderTrackings'] != null) {
      orderTrackings = <OrderTrackings>[];
      json['orderTrackings'].forEach((v) {
        orderTrackings!.add(new OrderTrackings.fromJson(v));
      });
    }
    if (json['orderDeliveries'] != null) {
      orderDeliveries = <OrderDeliveries>[];
      json['orderDeliveries'].forEach((v) {
        orderDeliveries!.add(new OrderDeliveries.fromJson(v));
      });
    }
    orderPayment = json['orderPayment'] != null ? new OrderPayment.fromJson(json['orderPayment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerName'] = this.customerName;
    data['locationId'] = this.locationId;
    data['customerAddress'] = this.customerAddress;
    data['customerEmail'] = this.customerEmail;
    data['customerMobile'] = this.customerMobile;
    data['customerMessage'] = this.customerMessage;
    data['customerOrdered'] = this.customerOrdered;
    data['totalOrderValue'] = this.totalOrderValue;
    data['deliveryType'] = this.deliveryType;
    data['deliveryPrice'] = this.deliveryPrice;
    data['preferredDropoffTime'] = this.preferredDropoffTime;
    data['preferredDeliverTime'] = this.preferredDeliverTime;
    data['status'] = this.status;
    if (this.orderedDetails != null) {
      data['orderedDetails'] = this.orderedDetails!.map((v) => v.toJson()).toList();
    }
    if (this.orderDetailTrackings != null) {
      data['orderDetailTrackings'] = this.orderDetailTrackings!.map((v) => v.toJson()).toList();
    }
    if (this.orderTrackings != null) {
      data['orderTrackings'] = this.orderTrackings!.map((v) => v.toJson()).toList();
    }
    if (this.orderDeliveries != null) {
      data['orderDeliveries'] = this.orderDeliveries!.map((v) => v.toJson()).toList();
    }
    if (this.orderPayment != null) {
      data['orderPayment'] = this.orderPayment!.toJson();
    }
    return data;
  }
}

class OrderedDetails {
  int? orderDetailId;
  String? serviceName;
  String? serviceCategory;
  num? measurement;
  String? unit;
  String? image;
  String? customerNote;
  String? staffNote;
  String? status;
  num? price;
  num? unitPrice;

  OrderedDetails(
      {this.orderDetailId,
      this.serviceName,
      this.serviceCategory,
      this.measurement,
      this.unit,
      this.image,
      this.customerNote,
      this.staffNote,
      this.status,
      this.price,
      this.unitPrice});

  OrderedDetails.fromJson(Map<String, dynamic> json) {
    orderDetailId = json['orderDetailId'];
    serviceName = json['serviceName'];
    serviceCategory = json['serviceCategory'];
    measurement = json['measurement'];
    unit = json['unit'];
    image = json['image'];
    customerNote = json['customerNote'];
    staffNote = json['staffNote'];
    status = json['status'];
    price = json['price'];
    unitPrice = json['unitPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDetailId'] = this.orderDetailId;
    data['serviceName'] = this.serviceName;
    data['serviceCategory'] = this.serviceCategory;
    data['measurement'] = this.measurement;
    data['unit'] = this.unit;
    data['image'] = this.image;
    data['customerNote'] = this.customerNote;
    data['staffNote'] = this.staffNote;
    data['status'] = this.status;
    data['price'] = this.price;
    data['unitPrice'] = this.unitPrice;
    return data;
  }
}

class OrderDetailTrackings {
  String? status;
  String? createdDate;
  String? updatedDate;

  OrderDetailTrackings({this.status, this.createdDate, this.updatedDate});

  OrderDetailTrackings.fromJson(Map<String, dynamic> json) {
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

class OrderDeliveries {
  String? shipperName;
  String? shipperPhone;
  int? locationId;
  bool? deliveryType;
  int? estimatedTime;
  String? deliveryDate;
  String? status;

  OrderDeliveries({this.shipperName, this.shipperPhone, this.locationId, this.deliveryType, this.estimatedTime, this.deliveryDate, this.status});

  OrderDeliveries.fromJson(Map<String, dynamic> json) {
    shipperName = json['shipperName'];
    shipperPhone = json['shipperPhone'];
    locationId = json['locationId'];
    deliveryType = json['deliveryType'];
    estimatedTime = json['estimatedTime'];
    deliveryDate = json['deliveryDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shipperName'] = this.shipperName;
    data['shipperPhone'] = this.shipperPhone;
    data['locationId'] = this.locationId;
    data['deliveryType'] = this.deliveryType;
    data['estimatedTime'] = this.estimatedTime;
    data['deliveryDate'] = this.deliveryDate;
    data['status'] = this.status;
    return data;
  }
}

class OrderPayment {
  num? paymentTotal;
  num? platformFee;
  String? dateIssue;
  String? status;
  int? paymentMethod;
  String? promoCode;
  num? discount;
  String? createdDate;
  String? updatedDate;

  OrderPayment(
      {this.paymentTotal,
      this.platformFee,
      this.dateIssue,
      this.status,
      this.paymentMethod,
      this.promoCode,
      this.discount,
      this.createdDate,
      this.updatedDate});

  OrderPayment.fromJson(Map<String, dynamic> json) {
    paymentTotal = json['paymentTotal'];
    platformFee = json['platformFee'];
    dateIssue = json['dateIssue'];
    status = json['status'];
    paymentMethod = json['paymentMethod'];
    promoCode = json['promoCode'];
    discount = json['discount'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentTotal'] = this.paymentTotal;
    data['platformFee'] = this.platformFee;
    data['dateIssue'] = this.dateIssue;
    data['status'] = this.status;
    data['paymentMethod'] = this.paymentMethod;
    data['promoCode'] = this.promoCode;
    data['discount'] = this.discount;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}

class OrderTrackings {
  String? status;
  String? createdDate;
  String? updatedDate;

  OrderTrackings({this.status, this.createdDate, this.updatedDate});

  OrderTrackings.fromJson(Map<String, dynamic> json) {
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
