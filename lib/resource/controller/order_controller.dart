import 'dart:convert';
//import 'dart:js';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:washouse_staff/resource/controller/base_controller.dart';
import 'package:washouse_staff/resource/model/order.dart';

import '../../components/constants/text_constants.dart';
import '../model/cart_item.dart';
import '../model/order_infomation.dart';
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

  Future<List<Order>> getOrderList(
      int? Page, int? PageSize, String? SearchString, String? FromDate, String? ToDate, String? Status, String? OrderType) async {
    List<Order> orderItems = [];
    try {
      String url = '$baseUrl/manager/my-center/orders';
      Map<String, dynamic> queryParams = {
        "Page": Page.toString(),
        "PageSize": PageSize.toString(),
        "SearchString": SearchString,
        "FromDate": FromDate,
        "ToDate": ToDate,
        "Status": Status,
        "OrderType": OrderType,
      };

      // queryParams = Map.fromEntries(queryParams.entries.where((e) => e.value != null && ['Page', 'PageSize'].contains(e.key)));
      // print(queryParams.toString());
      // queryParams.removeWhere((key, value) => value.value == 1);
      // print(queryParams.toString());
      Response response = await baseController.makeAuthenticatedRequest(url, queryParams);
      print(response.body);
      if (response.statusCode == 200) {
        // Handle successful response
        var data = jsonDecode(response.body)["data"]['items'] as List;
        orderItems = data.map((e) => Order.fromJson(e)).toList();
        // Do something with the user data...
      } else {
        // Handle error response
        throw Exception('Error fetching user data: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getOrderList-$e');
    }
    return orderItems;
  }

  Future<Order> getOrderById(String? orderId) async {
    var order = Order();
    try {
      String url = '$baseUrl/manager/my-center/orders?SearchString=$orderId';
      Response response = await baseController.makeAuthenticatedRequest(url, {});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["data"]['items'][0];
        order = Order.fromJson(data);
        print('order Id in controller: ${order.orderId}');
      } else {
        // Handle error response
        throw Exception('Error fetching order data: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getOrderById-$e');
    }
    return order;
  }

  Future<Order_Infomation> getOrderInformation(String orderId) async {
    var order_Infomation = new Order_Infomation();
    try {
      String url = '$baseUrl/manager/my-center/orders/$orderId';
      Response response = await baseController.makeAuthenticatedRequest(url, {});
      if (response.statusCode == 200) {
        // Handle successful response
        order_Infomation = Order_Infomation?.fromJson(jsonDecode(response.body)["data"]);
        print(order_Infomation.orderTrackings != null);
        // Do something with the user data...
      } else {
        // Handle error response
        throw Exception('Error fetching user data: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getOrderInformation-$e');
    }
    return order_Infomation;
  }

  Future<String?> createOrder(CartItem cart) async {
    String url = '$baseUrl/orders';
    Map<String, dynamic> queryParams = {};
    final headers = {'Content-Type': 'application/json'};
    http.Response response = await http.post(Uri.parse('$baseUrl/orders'), headers: headers, body: json.encode(cart.toJson()));
    dynamic responseData = json.decode(response.body);
    print(responseData);
    // Make the authenticated POST requests
    // http.Response response = await baseController.makeAuthenticatedPostRequest(
    //     url, queryParams, requestBody);

    // Check the response status code
    if (response.statusCode == 200) {
      // Request was successful, parse the response body
      dynamic responseData = json.decode(response.body);

      // Provider.of<CartProvider>(context, listen: false).removeCart();
      // baseController.printAllSharedPreferences();

      // Do something with the response data
      print(responseData);

      return responseData["data"]["orderId"];
    } else {
      // Request failed, handle the error
      dynamic responseData = json.decode(response.body);
      print(responseData);
    }
  }
}
