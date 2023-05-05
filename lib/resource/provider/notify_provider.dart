import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../components/constants/text_constants.dart';
import '../controller/base_controller.dart';
import '../model/response_model/notification_item_response.dart';

class NotifyProvider extends ChangeNotifier {
  int _numOfNotifications = 0;
  get numOfNotifications => _numOfNotifications;

  Future<NotificationResponse> getNotifications() async {
    NotificationResponse notificationResponse = NotificationResponse();
    try {
      String url = '$baseUrl/notifications/me-noti';
      Response response =
          await BaseController().makeAuthenticatedRequest(url, {});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["data"];
        notificationResponse = NotificationResponse.fromJson(data);
      } else {
        throw Exception(
            'Error fetching getNotifications: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getNotifications-$e');
    }
    return notificationResponse;
  }

  void getNoti() async {
    NotificationResponse notis = await getNotifications();
    _numOfNotifications = notis.numOfUnread!;
    print('hello');
    notifyListeners();
  }

  void readNoti() {
    _numOfNotifications--;
    notifyListeners();
  }

  void addNoti() {
    _numOfNotifications++;
    notifyListeners();
  }
}
