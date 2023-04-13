import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/constants/text_constants.dart';
import '../model/current_user.dart';
import '../model/customer.dart';
import '../model/response_model/login_response_model.dart';
import '../model/token.dart';
import 'base_controller.dart';

BaseController baseController = BaseController();

class AccountController {
  Future register(String phone, pass, conpass) async {
    //String? message;
    try {
      Map data = {
        "phone": phone,
        "email": "",
        "password": pass,
        "confirmPass": conpass
      };

      String body = json.encode(data);
      var url = '$baseUrl/accounts/customers';
      var response = await post(
        Uri.parse(url),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        //message = 'success';
        print("success");
      } else {
        throw Exception('Lỗi khi load json');
      }
    } catch (e) {
      print('error: $e');
    }
    //return message;
  }

  Future<CurrentUser> getCurrentUser() async {
    CurrentUser currentUser = new CurrentUser();
    try {
      String url = '$baseUrl/accounts/me';
      Response response =
          await baseController.makeAuthenticatedRequest(url, {});

      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle successful response
        currentUser = CurrentUser?.fromJson(jsonDecode(response.body)["data"]);
        //print(currentUser.name);
        // Do something with the user data...
      } else {
        // Handle error response
        throw Exception('Error fetching user data: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getCurrentUser-$e');
    }
    return currentUser;
  }

  Future login(String phone, String password) async {
    //String? message;
    LoginResponseModel? responseModel;
    try {
      Map data = {"phone": phone, "password": password};
      String body = jsonEncode(data);
      Response response = await post(
        Uri.parse('$baseUrl/accounts/login-staff'),
        body: body,
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8',
          "accept": "application/json",
          "access-control-allow-origin": "*",
        },
      );
      var statusCode = jsonDecode(response.body)["statusCode"];
      var message = jsonDecode(response.body)["message"];
      if (statusCode == 10) {
        return new LoginResponseModel(
            statusCode: 10, message: message, data: null);
      }
      if (statusCode == 17) {
        return new LoginResponseModel(
            statusCode: 17,
            message: "Admin không thể đăng nhập vào mobile",
            data: null);
      }

      Token? token = jsonDecode(response.body)["data"] != null
          ? Token?.fromJson(jsonDecode(response.body)["data"])
          : null;
      if (token != null) {
        responseModel = new LoginResponseModel(
            statusCode: statusCode, message: message, data: token);
      }
      if (statusCode == 0 && token != null) {
        var accessToken = token.accessToken;
        var refreshToken = token.refreshToken;
        if (accessToken != null && refreshToken != null) {
          await baseController.saveAccessToken(accessToken);
          await baseController.saveRefreshToken(refreshToken);
        }
      }
    } catch (e) {
      print('error login: $e');
    }
    return responseModel;
  }

  Future<Customer?> getCustomerInfomation(int accountId) async {
    Customer? currentCustomer = Customer();
    try {
      String url = '$baseUrl/customers/account/$accountId';
      Response response =
          await baseController.makeAuthenticatedRequest(url, {});
      if (response.statusCode == 200) {
        // Handle successful response
        currentCustomer = jsonDecode(response.body)["data"] != null
            ? Customer?.fromJson(jsonDecode(response.body)["data"])
            : null;
        //Map<String, dynamic> accountDetails = json.decode(response.body);
        return currentCustomer;
        //print(currentUser.name);
        // Do something with the user data...
      } else {
        // Handle error response
        throw Exception('Error fetching user data: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getCustomerInfomationByAccountId-$e');
      throw e;
    }
  }

  Future<String> changePassword(String oldPassword, String newPassword) async {
    int? userId =
        await baseController.getInttoSharedPreference("CURRENT_USER_ID");
    String url = '$baseUrl/accounts/$userId/change-password';
    Map<String, dynamic> queryParams = {};
    Map<String, dynamic> requestBody = {
      'oldPass': oldPassword,
      'newPass': newPassword
    };
    http.Response response = await baseController.makeAuthenticatedPutRequest(
        url, queryParams, requestBody);
    if (response.statusCode == 200) {
      return "change password success";
    } else {
      // Handle error changing password
      throw Exception('Error changing password: ${response.statusCode}');
    }
  }

  Future<String> changeProfilePicture(
      String SavedFileName, int accountId) async {
    String url = '$baseUrl/accounts/$accountId/profile-picture';
    Map<String, dynamic> queryParams = {'SavedFileName': SavedFileName};
    Map<String, dynamic> requestBody = {};
    print(SavedFileName);
    print(accountId);
    http.Response response = await baseController.makeAuthenticatedPutRequest(
        url, queryParams, requestBody);
    if (response.statusCode == 200) {
      return "update profile picture success";
    } else {
      // Handle error changing password
      throw Exception('Error changing password: ${response.statusCode}');
    }
  }
}
