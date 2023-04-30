import 'dart:convert';

import 'service.dart';

class OrderDetailItem {
  int serviceId;
  String serviceName;
  bool priceType;
  double? price;
  double? unitPrice;
  double measurement;
  String? customerNote;
  double? weight;
  double? minPrice;
  List<Prices>? prices;
  String? unit;
  String? staffNote;

  OrderDetailItem(
      {required this.serviceId,
      required this.serviceName,
      required this.priceType,
      this.price,
      this.unitPrice,
      required this.measurement,
      this.customerNote,
      this.weight,
      this.minPrice,
      this.prices,
      this.unit,
      this.staffNote});

  // OrderDetailItem.fromJson(Map<String, dynamic> json) {
  //   serviceId = json['serviceId'];
  //   serviceName = json['serviceName'];
  //   priceType = json['priceType'];
  //   price = json['price'];
  //   unitPrice = json['unitPrice'];
  //   measurement = json['measurement'];
  //   customerNote = json['customerNote'];
  //   weight = json['weight'];
  //   minPrice = json['minPrice'];
  //   prices = json['prices'];
  //   unit = json['unit'];
  //   staffNote = json['staffNote'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['serviceId'] = this.serviceId;
  //   data['serviceName'] = this.serviceName;
  //   data['priceType'] = this.priceType;
  //   data['price'] = this.price;
  //   data['unitPrice'] = this.unitPrice;
  //   data['measurement'] = this.measurement;
  //   data['customerNote'] = this.customerNote;
  //   data['weight'] = this.weight;
  //   data['minPrice'] = this.minPrice;
  //   data['prices'] = this.prices;
  //   data['unit'] = this.unit;
  //   data['staffNote'] = this.staffNote;
  //   return data;
  // }
  factory OrderDetailItem.fromJson(String jsonStr) => OrderDetailItem.fromMap(json.decode(jsonStr));

  String toJson() => json.encode(toMap());

  factory OrderDetailItem.fromMap(Map<String, dynamic> map) {
    return OrderDetailItem(
      serviceId: map['serviceId'],
      serviceName: map['serviceName'],
      priceType: map['priceType'],
      price: map['price'],
      unitPrice: map['unitPrice'],
      measurement: map['measurement'],
      customerNote: map['customerNote'],
      weight: map['weight'],
      minPrice: map['minPrice'],
      prices: List<Prices>.from(map['prices']?.map((x) => Prices.fromJson(x))),
      unit: map['unit'],
      staffNote: map['staffNote'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'priceType': priceType,
      'price': price,
      'unitPrice': unitPrice,
      'measurement': measurement,
      'customerNote': customerNote,
      'weight': weight,
      'minPrice': minPrice,
      'prices': List<dynamic>.from(prices?.map((x) => x.toJson()) ?? []),
      'unit': unit,
      'staffNote': staffNote,
    };
  }
}
