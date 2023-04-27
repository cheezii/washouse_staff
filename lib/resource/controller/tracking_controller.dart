import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../components/constants/text_constants.dart';
import 'base_controller.dart';

BaseController baseController = BaseController();

class TrackingController {
  Future<String> cancelledOrder(String orderId, String Reason) async {
    try {
      String url = '$baseUrl/tracking/orders/$orderId/cancelled';
      Map<String, dynamic> queryParams = {'Reason': Reason.toString()};
      Map<String, dynamic> requestBody = {};
      //print(queryParams.toString());
      Response response = await baseController.makeAuthenticatedPutRequest(url, queryParams, requestBody);
      var data = jsonDecode(response.body)["message"];
      if (response.statusCode == 200) {
        // Handle successful response
        return data;
        // Do something with the user data...
      } else {
        // Handle error response
        throw Exception('Error fetching cancelledOrder: ${response.statusCode}');
      }
    } catch (e) {
      print('error: paymentOrder-$e');
      return 'error_fetch';
    }
  }

  Future<String> trackingOrder(String orderId) async {
    try {
      String url = '$baseUrl/tracking/orders/$orderId/tracking';
      Map<String, dynamic> queryParams = {};
      Map<String, dynamic> requestBody = {};
      //print(queryParams.toString());
      Response response = await baseController.makeAuthenticatedPutRequest(url, queryParams, requestBody);
      var data = jsonDecode(response.body)["message"];
      if (response.statusCode == 200) {
        // Handle successful response
        return data;
        // Do something with the user data...
      } else {
        // Handle error response
        throw Exception('Error fetching cancelledOrder: ${response.statusCode}');
      }
    } catch (e) {
      print('error: paymentOrder-$e');
      return 'error_fetch';
    }
  }

  Future<String> trackingOrderDetail(String orderId, int orderDetailId) async {
    try {
      print(orderId);
      print(orderDetailId);

      String url = '$baseUrl/tracking/orders/$orderId/order-details/$orderDetailId/tracking';
      Map<String, dynamic> queryParams = {};
      Map<String, dynamic> requestBody = {};
      //print(queryParams.toString());
      Response response = await baseController.makeAuthenticatedPutRequest(url, queryParams, requestBody);
      var data = jsonDecode(response.body)["message"];
      if (response.statusCode == 200) {
        // Handle successful response
        return data;
        // Do something with the user data...
      } else {
        // Handle error response
        throw Exception('Error fetching trackingOrderDetail: ${response.statusCode}');
      }
    } catch (e) {
      print('error: trackingOrderDetail-$e');
      return 'error_fetch';
    }
  }

  Future<String> completeOrder(String orderId) async {
    try {
      String url = '$baseUrl/tracking/orders/$orderId/completed';
      Map<String, dynamic> queryParams = {};
      Map<String, dynamic> requestBody = {};
      //print(queryParams.toString());
      Response response = await baseController.makeAuthenticatedPutRequest(url, queryParams, requestBody);
      var data = jsonDecode(response.body)["message"];
      if (response.statusCode == 200) {
        // Handle successful response
        return data;
        // Do something with the user data...
      } else {
        // Handle error response
        throw Exception('Error fetching ccompletedOrder: ${response.statusCode}');
      }
    } catch (e) {
      print('error: completedOrder -$e');
      return 'error_fetch';
    }
  }
}
