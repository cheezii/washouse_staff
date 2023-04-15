import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/constants/text_constants.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class BaseController {
  // Define a function to get the value of a key from shared preferences
  Future<String?> getStringtoSharedPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int?> getInttoSharedPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<double?> getDoubletoSharedPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

// Define a function to save a string to shared preferences
  Future<void> saveStringtoSharedPreference(String saveName, dynamic? saveString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(saveName, saveString);
  }

  Future<void> saveInttoSharedPreference(String saveName, int? saveInt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(saveName, saveInt!);
  }

  Future<void> saveDoubletoSharedPreference(String saveName, double? saveInt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(saveName, saveInt!);
  }

  // Define a function to get the access token from shared preferences
  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    return accessToken;
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

  Future<http.Response> makeAuthenticatedRequest(String url, Map<String, dynamic> queryParams) async {
    String? accessToken = await getAccessToken();
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    http.Response response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
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
      print(response);
    }
  }

  Future<http.Response> makeAuthenticatedPutRequest(String url, Map<String, dynamic> queryParams, dynamic requestBody) async {
    String? accessToken = await getAccessToken();
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    http.Response response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );
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
        return makeAuthenticatedPutRequest(url, queryParams, requestBody);
      } else {
        // Handle error getting new tokens
        throw Exception('Error refreshing tokens: ${tokenResponse.statusCode}');
      }
    } else {
      // Return the original response
      return response;
    }
  }

  Future<http.Response> makeAuthenticatedPostRequest(String url, Map<String, dynamic> queryParams, dynamic requestBody) async {
    String? accessToken = await getAccessToken();
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    http.Response response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );
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
        return makeAuthenticatedPostRequest(url, queryParams, requestBody);
      } else {
        // Handle error getting new tokens
        throw Exception('Error refreshing tokens: ${tokenResponse.statusCode}');
      }
    } else {
      // Return the original response
      return response;
    }
  }

  Future<http.Response> makeAuthenticatedPostRequestWithFile(String url, Map<String, dynamic> queryParams, File imageFile) async {
    String? accessToken = await getAccessToken();
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    // Create a multipart request
    http.MultipartRequest request = http.MultipartRequest('POST', uri);

    // Add headers to the request
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add the image file to the request
    String fileName = imageFile.path.split('/').last;
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path, filename: fileName));

    // Send the request
    http.StreamedResponse response = await request.send();

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
        return makeAuthenticatedPostRequestWithFile(url, queryParams, imageFile);
      } else {
        // Handle error getting new tokens
        throw Exception('Error refreshing tokens: ${tokenResponse.statusCode}');
      }
    } else {
      // Return the response
      return http.Response.fromStream(response);
    }
  }

  Future<Map<String, String>> uploadImage(File imageFile) async {
    String url = '$baseUrl/medias';
    Map<String, dynamic> queryParams = {};
    //String filePath = '/path/to/image.jpg';
    http.Response response = await makeAuthenticatedPostRequestWithFile(url, queryParams, imageFile);

    // handle response
    if (response.statusCode == 200) {
      // Success
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String savedUrl = jsonResponse['data']['savedUrl'];
      String savedFileName = jsonResponse['data']['savedFileName'];
      String signedUrl = jsonResponse['data']['signedUrl'];
      return {
        'savedUrl': savedUrl,
        'signedUrl': signedUrl,
        'savedFileName': savedFileName,
      };
    } else {
      // Handle error
      throw Exception('Error uploading image: ${response.statusCode}');
    }
  }

  Future<Map<String, String>> upload(File file) async {
    String url = '$baseUrl/medias';
    // Create the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // Add the file to the request
    // Add the file to the request
    final fileStream = new http.ByteStream(file.openRead());
    final fileLength = await file.length();
    print(fileLength);
    final multipartFile = http.MultipartFile(
      'Photo',
      fileStream,
      fileLength,
      filename: file.path.split('/').last,
    );
    request.files.add(multipartFile);

// Send the request
    final _response = await request.send();

    final response = await _response.stream.bytesToString();

// Check the response
    if (_response.statusCode == 200) {
      // Success
      Map<String, dynamic> jsonResponse = json.decode(response);
      String savedUrl = jsonResponse['data']['savedUrl'];
      String savedFileName = jsonResponse['data']['savedFileName'];
      String signedUrl = jsonResponse['data']['signedUrl'];
      return {
        'savedUrl': savedUrl,
        'signedUrl': signedUrl,
        'savedFileName': savedFileName,
      };
    } else {
      // Handle error
      throw Exception('Error uploading image: ${_response.statusCode}');
    }
  }
}
