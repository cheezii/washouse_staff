class ServiceCenter {
  num? serviceId;
  num? categoryId;
  String? serviceName;
  String? description;
  String? image;
  bool? priceType;
  num? price;
  num? minPrice;
  String? unit;
  num? rate;
  List<Prices>? prices;
  num? timeEstimate;
  num? rating;
  num? numOfRating;
  List<int>? ratings;

  ServiceCenter(
      {this.serviceId,
      this.categoryId,
      this.serviceName,
      this.description,
      this.image,
      this.priceType,
      this.price,
      this.minPrice,
      this.unit,
      this.rate,
      this.prices,
      this.timeEstimate,
      this.rating,
      this.numOfRating,
      this.ratings});

  ServiceCenter.fromJson(Map<String, dynamic> json) {
    serviceId = json['serviceId'];
    categoryId = json['categoryId'];
    serviceName = json['serviceName'];
    description = json['description'];
    image = json['image'];
    priceType = json['priceType'];
    price = json['price'];
    minPrice = json['minPrice'];
    unit = json['unit'];
    rate = json['rate'];
    if (json['prices'] != null) {
      prices = <Prices>[];
      json['prices'].forEach((v) {
        prices!.add(new Prices.fromJson(v));
      });
    }
    timeEstimate = json['timeEstimate'];
    rating = json['rating'];
    numOfRating = json['numOfRating'];
    ratings = json['ratings'].cast<int>();
  }
}

class Prices {
  num? maxValue;
  num? price;

  Prices({this.maxValue, this.price});

  Prices.fromJson(Map<String, dynamic> json) {
    maxValue = json['maxValue'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxValue'] = this.maxValue;
    data['price'] = this.price;
    return data;
  }
}
