class CartItem {
  int? centerId;
  OrderRequest? orderRequest;
  List<OrderDetailRequest>? orderDetails;
  List<DeliveryRequest>? deliveries;
  String? promoCode;
  int? paymentMethod;

  CartItem({this.centerId, this.orderRequest, this.orderDetails, this.deliveries, this.promoCode, this.paymentMethod});

  CartItem.fromJson(Map<String, dynamic> json) {
    centerId = json['centerId'];
    orderRequest = json['orderRequest'] != null ? new OrderRequest.fromJson(json['orderRequest']) : null;
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetailRequest>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(new OrderDetailRequest.fromJson(v));
      });
    }
    if (json['deliveries'] != null) {
      deliveries = <DeliveryRequest>[];
      json['deliveries'].forEach((v) {
        deliveries!.add(new DeliveryRequest.fromJson(v));
      });
    }
    promoCode = json['promoCode'];
    paymentMethod = json['paymentMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['centerId'] = this.centerId;
    if (this.orderRequest != null) {
      data['orderRequest'] = this.orderRequest!.toJson();
    }
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails!.map((v) => v.toJson()).toList();
    }
    if (this.deliveries != null) {
      data['deliveries'] = this.deliveries!.map((v) => v.toJson()).toList();
    }
    data['promoCode'] = this.promoCode;
    data['paymentMethod'] = this.paymentMethod;
    return data;
  }
}

class OrderRequest {
  String? customerName;
  String? customerAddressString;
  int? customerWardId;
  String? customerEmail;
  String? customerMobile;
  String? customerMessage;
  int? deliveryType;
  double? deliveryPrice;
  String? preferredDropoffTime;

  OrderRequest(
      {this.customerName,
      this.customerAddressString,
      this.customerWardId,
      this.customerEmail,
      this.customerMobile,
      this.customerMessage,
      this.deliveryType,
      this.deliveryPrice,
      this.preferredDropoffTime});

  OrderRequest.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    customerAddressString = json['customerAddressString'];
    customerWardId = json['customerWardId'];
    customerEmail = json['customerEmail'];
    customerMobile = json['customerMobile'];
    customerMessage = json['customerMessage'];
    deliveryType = json['deliveryType'];
    deliveryPrice = json['deliveryPrice'];
    preferredDropoffTime = json['preferredDropoffTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['customerAddressString'] = this.customerAddressString;
    data['customerWardId'] = this.customerWardId;
    data['customerEmail'] = this.customerEmail;
    data['customerMobile'] = this.customerMobile;
    data['customerMessage'] = this.customerMessage;
    data['deliveryType'] = this.deliveryType;
    data['deliveryPrice'] = this.deliveryPrice;
    data['preferredDropoffTime'] = this.preferredDropoffTime;
    return data;
  }
}

class OrderDetailRequest {
  int? serviceId;
  double? measurement;
  double? price;
  String? customerNote;
  String? staffNote;

  OrderDetailRequest({this.serviceId, this.measurement, this.price, this.customerNote, this.staffNote});

  OrderDetailRequest.fromJson(Map<String, dynamic> json) {
    serviceId = json['serviceId'];
    measurement = json['measurement'];
    price = json['price'];
    customerNote = json['customerNote'];
    staffNote = json['staffNote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceId'] = this.serviceId;
    data['measurement'] = this.measurement;
    data['price'] = this.price;
    data['customerNote'] = this.customerNote;
    data['staffNote'] = this.staffNote;
    return data;
  }
}

class DeliveryRequest {
  String? addressString;
  int? wardId;
  bool? deliveryType;

  DeliveryRequest({this.addressString, this.wardId, this.deliveryType});

  DeliveryRequest.fromJson(Map<String, dynamic> json) {
    addressString = json['addressString'];
    wardId = json['wardId'];
    deliveryType = json['deliveryType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressString'] = this.addressString;
    data['wardId'] = this.wardId;
    data['deliveryType'] = this.deliveryType;
    return data;
  }
}
