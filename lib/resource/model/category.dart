// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:washouse_staff/resource/model/service.dart';

class ServiceCategory {
  int? id;
  String? categoryName;
  String? alias;
  String? description;
  String? image;
  bool? status;
  bool? homeFlag;
  List<ServiceCenter>? services;
  String? createdDate;
  String? createdBy;
  String? updatedDate;
  String? updatedBy;

  ServiceCategory(
      {this.id,
      this.categoryName,
      this.alias,
      this.description,
      this.image,
      this.status,
      this.homeFlag,
      this.services,
      this.createdDate,
      this.createdBy,
      this.updatedDate,
      this.updatedBy});

  ServiceCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    alias = json['alias'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    homeFlag = json['homeFlag'];
    if (json['services'] != null) {
      services = <ServiceCenter>[];
      json['services'].forEach((v) {
        services!.add(new ServiceCenter.fromJson(v));
      });
    }
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    updatedDate = json['updatedDate'];
    updatedBy = json['updatedBy'];
  }
}
