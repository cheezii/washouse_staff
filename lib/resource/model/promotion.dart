// ignore_for_file: public_member_api_docs, sort_constructors_first
class PromotionModel {
  late String code;
  String? description;
  late double discount;
  late String startDate;
  late String expireDate;
  int? useTimes;
  late bool isAvailable;

  PromotionModel(
      {required this.code,
      this.description,
      required this.discount,
      required this.startDate,
      required this.expireDate,
      this.useTimes,
      required this.isAvailable});

  PromotionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    discount = json['discount'];
    startDate = json['startDate'];
    expireDate = json['expireDate'];
    useTimes = json['useTimes'];
    isAvailable = json['isAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['startDate'] = this.startDate;
    data['expireDate'] = this.expireDate;
    data['useTimes'] = this.useTimes;
    data['IsAvailable'] = this.isAvailable;
    return data;
  }
}

// List<PromotionModel> demoPromotionList = [
//   PromotionModel(
//     id: 1,
//     code: 'TEST_DRCLEAN_FAIL',
//     expiredDate: '2023-06-30',
//     description: 'Sử dụng trong tháng 6',
//   ),
//   PromotionModel(
//     id: 1,
//     code: 'TEST_DRCLEAN_OK',
//     expiredDate: '2023-04-25',
//     description: 'Sử dụng đến hết ngày 20/4/2023',
//   ),
//   PromotionModel(
//     id: 1,
//     code: 'TEST_DRCLEAN_FAIL',
//     expiredDate: '2023-04-02',
//     description: 'Sử dụng cho khách hàng',
//   )
// ];
