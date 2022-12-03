// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/constants.dart';
import '../models/response/error_response.dart';

class ApiClient extends GetConnect implements GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;

  String? token;
  Map<String, String>? _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    try {
      baseUrl = appBaseUrl;
      timeout = const Duration(seconds: 30);
      token = sharedPreferences.getString(AppConstants.token) ?? '';
      if (kDebugMode) {
        print('Token: $token');
      }
      _mainHeaders = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } catch (e) {
      log('******** ${e.toString()} ********+', name: "ERROR AT ApiClient()");
    }
  }

  void updateHeader(String? token) {
    _mainHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
  }) async {
    try {
      if (kDebugMode) {
        log('====> GetX Call: $uri\nToken: $token');
      }
      Response response = await get(
        uri,
        contentType: contentType,
        query: query,
        headers: headers ?? _mainHeaders,
        decoder: decoder,
      );
      // log('aasdas'+response.bodyString!+'aasdas',name: '$uri');

      log('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      response = handleResponse(response);
      if (kDebugMode) {
        // log('====> GetX Response: [${response.statusCode}] $uri\n${uri.contains('astros') || uri.contains('shop') || uri.contains('shop') ? response.body[0] : response.body}');
      }
      return response;
    } catch (e) {
      // log("$e",name: 'ERROR $uri');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(
    String uri,
    dynamic body, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
    Function(double)? uploadProgress,
  }) async {
    try {
      if (kDebugMode) {
        log('====> GetX Call: $uri\nToken: $token');
        log('====> GetX Body: $body', name: uri);
      }
      Response response = await post(
        uri,
        body,
        query: query,
        contentType: contentType,
        headers: headers ?? _mainHeaders,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
      log('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      response = handleResponse(response);
      log('====> GetX Response: [${response.statusCode}] $uri');
      if (kDebugMode) {
        // print('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      }
      return response;
    } catch (e) {
      log('$e', name: 'ERROR AT POST');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(
    String uri,
    dynamic body, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
    Function(double)? uploadProgress,
  }) async {
    try {
      if (kDebugMode) {
        print('====> GetX Call: $uri\nToken: $token');
        print('====> GetX Body: $body');
      }
      Response response = await put(
        uri,
        body,
        query: query,
        contentType: contentType,
        headers: headers ?? _mainHeaders,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
      response = handleResponse(response);
      log('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      if (kDebugMode) {
        // print('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      }
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> patchData(
    String uri,
    dynamic body, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
    Function(double)? uploadProgress,
  }) async {
    try {
      if (kDebugMode) {
        print('====> GetX Call: $uri\nToken: $token');
        print('====> GetX Body: $body');
      }
      Response response = await patch(
        uri,
        body,
        query: query,
        contentType: contentType,
        headers: headers ?? _mainHeaders,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
      response = handleResponse(response);
      log('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      if (kDebugMode) {
        // print('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      }
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(
    String uri, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
  }) async {
    try {
      if (kDebugMode) {
        print('====> GetX Call: $uri\nToken: $token');
      }
      Response response = await delete(
        uri,
        headers: headers ?? _mainHeaders,
        contentType: contentType,
        query: query,
        decoder: decoder,
      );
      response = handleResponse(response);
      log('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      if (kDebugMode) {
        // print('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      }
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Response handleResponse(Response response) {
    Response _response = response;
    if (_response.hasError && _response.body != null && _response.body is! String) {
      if (_response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: errorResponse.errors[0].message);
      } else if (_response.body.toString().startsWith('{message')) {
        _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _response.body['message']);
      }
    } else if (_response.hasError && _response.body == null) {
      log(_response.statusCode.toString(), name: "STATUS CODE");
      _response = const Response(statusCode: 0, statusText: 'Connection to API server failed due to internet connection');
    }
    return _response;
  }

  Future<dynamic> commonApiCall(String urlR, Map<String, dynamic> body) async {
    var postUri = Uri.parse(/*AppConstants().getBaseUrl +*/ urlR);
    log(urlR);
    log(body.toString());
    late http.Response response;
    try {
      response = await http.post(
        postUri,
        body: body,
        headers: _mainHeaders,
      );
      log('response.bodyresponse.body');
      log(response.body);
      // log(response.body.length.toString());
      // log(response.body.substring(0,response.body.length));
      log("/${response.request!.url.path.split('/').last} ============ ${response.statusCode}\n", name: "API SUCCESS PATH CAC");

      return response;
    } catch (e) {
      log("/${postUri.path.split('/').last} ============ " /*+ getResponseStatus(response)*/, name: "API FAILURE PATH CAC");
      log('+++++++ ${e.toString().replaceAll('\n', ' ')} +++++++\n',
          name: "API ERROR CAC(/${"${postUri.path.split('/').last} ============ " /*+ getResponseStatus(response)*/})", level: 1);
      return null;
    }
  }

  Future<dynamic> commonApiCallGet(String url) async {
    var postUri = Uri.parse(/*AppConstants().getBaseUrl +*/ url);
    // log(urlR);
    // log(body.toString());
    late http.Response response;
    try {
      response = await http.get(
        postUri,
        headers: _mainHeaders,
      );
      log('response.bodyresponse.body');
      log(response.body);
      // log(response.body.length.toString());
      // log(response.body.substring(0,response.body.length));
      log("/${response.request!.url.path.split('/').last} ============ ${response.statusCode}\n", name: "API SUCCESS PATH CAC");

      return response;
    } catch (e) {
      log("/${postUri.path.split('/').last} ============ " /*+ getResponseStatus(response)*/, name: "API FAILURE PATH CAC");
      log('+++++++ ${e.toString().replaceAll('\n', ' ')} +++++++\n',
          name: "API ERROR CAC(/${"${postUri.path.split('/').last} ============ " /*+ getResponseStatus(response)*/})", level: 1);
      return null;
    }
  }
}
