import 'dart:convert';

import 'package:http/http.dart';
import 'package:washouse_staff/resource/controller/base_controller.dart';
import 'package:washouse_staff/resource/model/order.dart';

import '../../components/constants/text_constants.dart';

class OrderController {
  BaseController baseController = BaseController();
  List<Order> orderList = [];
  // Future<List<Order>> getOrderList() async {
  //   try {
  //     String url = '$baseUrl/manager/my-center';
  //     Response response =
  //         await baseController.makeAuthenticatedRequest(url, {});
  //     if (response.statusCode == 200) {
  //       // Handle successful response
  //       currentCenter = jsonDecode(response.body)["data"] != null
  //           ? LaundryCenter?.fromJson(jsonDecode(response.body)["data"])
  //           : null;
  //       return currentCenter;
  //     } else {
  //       throw Exception('Error fetching center data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('error: getCenterInfomationByCenterId-$e');
  //     throw e;
  //   }
  // }
}
