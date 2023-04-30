class Customer {
  int? id;
  int? accountId;
  String? fullname;
  String? phone;
  String? email;
  String? profilePic;
  String? addressString;
  Address? address;
  int? walletId;
  int? gender;
  String? dob;

  Customer(
      {this.id,
      this.accountId,
      this.fullname,
      this.phone,
      this.email,
      this.profilePic,
      this.addressString,
      this.address,
      this.walletId,
      this.gender,
      this.dob});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountId = json['accountId'];
    fullname = json['fullname'];
    phone = json['phone'];
    email = json['email'];
    profilePic = json['profilePic'];
    addressString = json['addressString'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    walletId = json['walletId'];
    gender = json['gender'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accountId'] = this.accountId;
    data['fullname'] = this.fullname;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['profilePic'] = this.profilePic;
    data['addressString'] = this.addressString;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['walletId'] = this.walletId;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    return data;
  }
}

class Address {
  int? id;
  String? addressString;
  Ward? ward;
  double? latitude;
  double? longitude;

  Address(
      {this.id, this.addressString, this.ward, this.latitude, this.longitude});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressString = json['addressString'];
    ward = json['ward'] != null ? new Ward.fromJson(json['ward']) : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressString'] = this.addressString;
    if (this.ward != null) {
      data['ward'] = this.ward!.toJson();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Ward {
  int? wardId;
  String? wardName;
  District? district;

  Ward({this.wardId, this.wardName, this.district});

  Ward.fromJson(Map<String, dynamic> json) {
    wardId = json['wardId'];
    wardName = json['wardName'];
    district = json['district'] != null
        ? new District.fromJson(json['district'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wardId'] = this.wardId;
    data['wardName'] = this.wardName;
    if (this.district != null) {
      data['district'] = this.district!.toJson();
    }
    return data;
  }
}

class District {
  int? districtId;
  String? districtName;

  District({this.districtId, this.districtName});

  District.fromJson(Map<String, dynamic> json) {
    districtId = json['districtId'];
    districtName = json['districtName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtId'] = this.districtId;
    data['districtName'] = this.districtName;
    return data;
  }
}
// // ignore_for_file: public_member_api_docs, sort_constructors_first
// class Customer {
//   int id;
//   int accountId;
//   String firstName;
//   String lastName;
//   String? gender;
//   DateTime? dob;
//   String address;
//   String phone;
//   String email;
//   String password;
//   bool status;
//   Customer({
//     required this.id,
//     required this.accountId,
//     required this.firstName,
//     required this.lastName,
//     this.gender,
//     this.dob,
//     required this.address,
//     required this.phone,
//     required this.email,
//     required this.password,
//     required this.status,
//   });
// }

// // Customer customer = Customer(
// //   id: 1,
// //   accountId: 'chipnq',
// //   firstName: 'Chi',
// //   lastName: 'Phan',
// //   gender: 'F',
// //   dob: DateTime(2001, 1, 26),
// //   address: '477 Man Thiện',
// //   phone: '0945620313',
// //   email: 'chipnquynh@gmail.com',
// //   password: '123456',
// //   status: true,
// // );
