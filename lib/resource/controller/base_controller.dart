import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/constants/text_constants.dart';

class BaseController {
  // Define a function to get the value of a key from shared preferences
  Future<String?> getStringtoSharedPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

// Define a function to save a string to shared preferences
  Future<void> saveStringtoSharedPreference(
      String saveName, dynamic? saveString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(saveName, saveString);
  }

  // Define a function to get the access token from shared preferences
  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

// Define a function to save the access token to shared preferences
  Future<void> saveAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

// Define a function to get the refresh token from shared preferences
  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

// Define a function to save the refresh token to shared preferences
  Future<void> saveRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  Future<http.Response> makeAuthenticatedRequest(
      String url, Map<String, dynamic> queryParams) async {
    String? accessToken = await getAccessToken();
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    http.Response response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(url + queryParams.keys.first);
    if (response.statusCode == 401) {
      // If the access token is expired, use the refresh token to get a new one
      String? refreshToken = await getRefreshToken();
      http.Response tokenResponse = await http.post(
        Uri.parse('$baseUrl/accounts/token'),
        body: {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        },
      );
      if (tokenResponse.statusCode == 200) {
        // Save the new access and refresh tokens
        Map<String, dynamic> tokenJson = json.decode(tokenResponse.body);
        String newAccessToken = tokenJson['access_token'];
        String newRefreshToken = tokenJson['refresh_token'];
        await saveAccessToken(newAccessToken);
        await saveRefreshToken(newRefreshToken);
        // Make the original request again with the new access token
        return makeAuthenticatedRequest(url, {});
      } else {
        // Handle error getting new tokens
        throw Exception('Error refreshing tokens: ${tokenResponse.statusCode}');
      }
    } else {
      // Return the original response
      return response;
    }
  }
}
