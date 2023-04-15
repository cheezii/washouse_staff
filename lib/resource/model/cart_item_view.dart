class OrderDetailItem {
  int? serviceId;
  String? serviceName;
  double? unitPrice;
  double? measurement;
  double? price;
  double? weight;
  String? customerNote;
  String? staffNote;

  OrderDetailItem({this.serviceId, this.measurement, this.price, this.weight, this.customerNote, this.staffNote, this.serviceName, this.unitPrice});

  OrderDetailItem.fromJson(Map<String, dynamic> json) {
    serviceId = json['serviceId'];
    serviceName = json['serviceName'];
    unitPrice = json['unitPrice'];
    measurement = json['measurement'];
    price = json['price'];
    weight = json['weight'];
    customerNote = json['customerNote'];
    staffNote = json['staffNote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceId'] = this.serviceId;
    data['serviceName'] = this.serviceName;
    data['unitPrice'] = this.unitPrice;
    data['measurement'] = this.measurement;
    data['price'] = this.price;
    data['weight'] = this.weight;
    data['customerNote'] = this.customerNote;
    data['staffNote'] = this.staffNote;
    return data;
  }
}