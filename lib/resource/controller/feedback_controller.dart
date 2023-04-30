import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../components/constants/text_constants.dart';
import '../model/feedback.dart';
import 'base_controller.dart';

BaseController baseController = BaseController();

class FeedbackController {
  Future<List<FeedbackModel>?> getCenterFeedback() async {
    List<FeedbackModel>? feedbacks = [];
    try {
      String url = '$baseUrl/manager/my-center/feedbacks';
      Map<String, dynamic> queryParams = {'Page': '1', 'PageSize': '20'};
      Response response = await baseController.makeAuthenticatedRequest(url, queryParams);
      print(response.body);
      if (response.statusCode == 200) {
        // Handle successful response
        var data = jsonDecode(response.body)['data']['items'] as List;
        feedbacks = data.map((e) => FeedbackModel.fromJson(e)).toList();
        return feedbacks; // Return the feedbacks list to the caller
      } else {
        // Error response
        throw Exception('Error fetching feedbacks data: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getCenterFeedback-$e');
      throw e;
    }
  }
}
