import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:washouse_staff/resource/controller/account_controller.dart';
import 'package:washouse_staff/resource/model/center.dart';

import '../../components/constants/text_constants.dart';

class CenterController {
  Future<LaundryCenter?> getCenterInfomation() async {
    LaundryCenter? currentCenter = LaundryCenter();
    try {
      String url = '$baseUrl/manager/my-center';
      Response response = await baseController.makeAuthenticatedRequest(url, {});
      if (response.statusCode == 200) {
        // Handle successful response
        currentCenter = jsonDecode(response.body)["data"] != null ? LaundryCenter?.fromJson(jsonDecode(response.body)["data"]) : null;
        //Map<String, dynamic> accountDetails = json.decode(response.body);
        return currentCenter;
        //print(currentUser.name);
        // Do something with the user data...
      } else {
        // Handle error response
        throw Exception('Error fetching center data: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getCenterInfomationByCenterId-$e');
      throw e;
    }
  }

  Future<LaundryCenter> getCenterById(int centerId) async {
    Response response = await get(Uri.parse('$baseUrl/centers/$centerId'));
    LaundryCenter center = LaundryCenter();
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        center = LaundryCenter.fromJson(data);
      } else {
        throw Exception('Error fetching user data: ${response.statusCode}');
      }
    } catch (e) {
      print('get service error: $e');
    }
    return center;
  }
}
