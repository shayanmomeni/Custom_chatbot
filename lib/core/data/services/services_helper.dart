import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/core/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:decent_chatbot/app_repo.dart';

class ServicesHelper {
  final String baseURL = AppConfig().baseURL;
  final int pageSize = 50;
  final int timeout = 30;

  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppRepo().jwtToken}'
      };

  String queryMaker(Map<String, dynamic> parameters) {
    String query = '';
    parameters.forEach((key, value) {
      if (query.isEmpty) {
        query = '?$key=$value';
      } else {
        query = '$query&$key=$value';
      }
    });

    return query;
  }

  Future<dynamic> request(
    String url, {
    required ServiceType serviceType,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiredDefaultHeader = false,
    String contentType = 'application/json',
  }) async {
    final uri = Uri.parse(url);

    // Prepare headers
    Map<String, String> newHeaders = {};
    if (requiredDefaultHeader) {
      newHeaders = defaultHeaders; // Use token if required
    } else {
      newHeaders['Content-Type'] =
          contentType; // No token for non-authenticated routes
    }

    // Prepare body
    dynamic encodedBody;
    if (contentType == 'application/json') {
      encodedBody = jsonEncode(body);
    } else if (contentType == 'application/x-www-form-urlencoded' &&
        body != null) {
      encodedBody = Uri(queryParameters: body).query;
    }

    try {
      http.Response? response;
      final client = http.Client();
      final durationTimeOut = Duration(seconds: timeout);

      // Send request based on service type
      switch (serviceType) {
        case ServiceType.post:
          response = await client
              .post(uri, body: encodedBody, headers: headers ?? newHeaders)
              .timeout(durationTimeOut);
          break;
        case ServiceType.get:
          response = await client
              .get(uri, headers: headers ?? newHeaders)
              .timeout(durationTimeOut);
          break;
        case ServiceType.delete:
          response = await client
              .delete(uri,
                  body: body != null ? encodedBody : null,
                  headers: headers ?? newHeaders)
              .timeout(durationTimeOut);
          break;
        case ServiceType.patch:
        case ServiceType.put:
          response = await client
              .put(uri, body: encodedBody, headers: headers ?? newHeaders)
              .timeout(durationTimeOut);
          break;
      }

      // Handle response
      return _responseHandler(response);
    } on TimeoutException catch (_) {
      debugPrint('Connection timeout');
      return null;
    } on SocketException catch (socketError) {
      debugPrint('socketError: $socketError');
      AppRepo().networkConnectivity = false;
      AppRepo().networkConnectivityStream.add(1);

      return null;
    } catch (error) {
      debugPrint('General error: $error');
      return null;
    }
  }

  Future<dynamic> _responseHandler(http.Response response) async {
    debugPrint('statusCode: ${response.statusCode}');
    debugPrint('body: ${response.body}');

    // Additional debug for image responses
    try {
      final responseBody = jsonDecode(response.body);
      if (responseBody['data'] != null &&
          responseBody['data']['images'] != null) {
        debugPrint(
            'Images received from backend: ${responseBody['data']['images']}');
      }
    } catch (e) {
      debugPrint('Error decoding response for images: $e');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // Successful response
    } else if (response.statusCode == 401) {
      // Prevent retry logic for unauthorized login endpoints
      debugPrint('Unauthorized error. Retry is not allowed for login.');
      return null;
    } else if (response.statusCode == 429) {
      Get.snackbar(
        'Server Error',
        'Too many requests. Please try again later.',
      );
      return null;
    } else {
      final message = jsonDecode(response.body);

      if (message['message'] is List<dynamic>) {
        Get.snackbar(
          message['error'] ?? '',
          (message['message'].join('\n')) ?? '',
        );
      } else {
        Get.snackbar(
          message['error'] ?? 'Error',
          message['message'] ?? 'Something went wrong!',
        );
      }

      debugPrint('Error: $message');
      return null;
    }
  }
}
