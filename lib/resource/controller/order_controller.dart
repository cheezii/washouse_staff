import 'dart:convert';
import 'dart:js';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:washouse_staff/resource/controller/base_controller.dart';
import 'package:washouse_staff/resource/model/order.dart';

import '../../components/constants/text_constants.dart';
import '../model/cart_item.dart';
import '../provider/cart_provider.dart';

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

  Future<double> calculateDeliveryPrice(
      double totalWeight, String? DropoffAddress, int? DropoffWardId, String? DeliverAddress, int? DeliverWardId, int DeliveryType) async {
    String url = '$baseUrl/orders/delivery-price';
    // CartItem _CartItem = Provider.of<CartProvider>(context as BuildContext, listen: false).cartItem;
    // double totalWeight = 0;
    // for (var element in _CartItem.orderDetails!) {
    //   if (element.weight != null) {
    //     totalWeight = totalWeight + element.measurement * element.weight!;
    //   }
    // }
    late Map<String, dynamic> queryParams;
    if (DeliveryType == 3) {
      queryParams = {
        'CenterId': await baseController.getInttoSharedPreference("CENTER_ID"),
        'TotalWeight': totalWeight,
        'DropoffAddress': DropoffAddress,
        'DropoffWardId': DropoffWardId ?? 0,
        'DeliverAddress': DeliverAddress,
        'DeliverWardId': DeliverWardId ?? 0,
        'DeliveryType': 3
      };
    } else if (DeliveryType == 1) {
      queryParams = {
        'CenterId': await baseController.getInttoSharedPreference("CENTER_ID"),
        'TotalWeight': totalWeight,
        'DropoffAddress': DropoffAddress,
        'DropoffWardId': DropoffWardId ?? 0,
        'DeliveryType': 1
      };
    } else if (DeliveryType == 2) {
      queryParams = {
        'CenterId': await baseController.getInttoSharedPreference("CENTER_ID"),
        'TotalWeight': totalWeight,
        'DeliverAddress': DeliverAddress,
        'DeliverWardId': DeliverWardId ?? 0,
        'DeliveryType': 2
      };
    }

    print(queryParams.toString());
    final response =
        await http.get(Uri.parse(url + '?' + Uri(queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString()))).query));
    dynamic responseData = json.decode(response.body);
    print(responseData["message"]);
    // Make the authenticated POST requests
    // http.Response response = await baseController.makeAuthenticatedPostRequest(
    //     url, queryParams, requestBody);

    // Check the response status code
    if (response.statusCode == 200) {
      // Request was successful, parse the response body
      dynamic responseData = json.decode(response.body);
      // Do something with the response data
      return responseData["data"]["deliveryPrice"];
    } else {
      // Request failed, handle the error
      print(responseData["message"]);

      return 0;
    }
  }
}
