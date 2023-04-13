class CenterDeliveryPrice {
  late int id;
  late double maxDistance;
  late double maxWeight;
  late double price;

  CenterDeliveryPrice(
      {required this.id,
      required this.maxDistance,
      required this.maxWeight,
      required this.price});

  CenterDeliveryPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maxDistance = json['maxDistance'];
    maxWeight = json['maxWeight'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['maxDistance'] = this.maxDistance;
    data['maxWeight'] = this.maxWeight;
    data['price'] = this.price;
    return data;
  }
}
