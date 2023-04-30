import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../components/constants/text_constants.dart';
import '../model/response_model/notification_item_response.dart';
import 'base_controller.dart';

BaseController baseController = BaseController();

class NotificationController {
  Future<NotificationResponse> getNotifications() async {
    NotificationResponse notificationResponse = NotificationResponse();
    try {
      String url = '$baseUrl/notifications/me-noti';
      Response response = await baseController.makeAuthenticatedRequest(url, {});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["data"];
        notificationResponse = NotificationResponse.fromJson(data);
      } else {
        throw Exception('Error fetching getNotifications: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getNotifications-$e');
    }
    return notificationResponse;
  }
}
