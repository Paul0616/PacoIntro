import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pacointro/models/credentials_model.dart';

import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/token_response_model.dart';
import 'package:pacointro/repository/api_response1.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'package:pacointro/repository/repository_interface.dart';
import 'package:http/http.dart' as http;
import 'package:pacointro/utils/constants.dart';

class Repository extends PreferencesRepository implements DataSource {
  final http.Client httpClient;
  final String baseUrl = 'http://paco-api.bavial.ro';

  @override
  void dispose() {}

  Repository({@required this.httpClient}) : assert(httpClient != null);

  @override
  Future<Map<String, dynamic>> checkUser() async {
    Map<String, String> headers = new Map<String, String>();
    TokenResponseModel tokenResponse = await getLocalToken();
    headers['Authorization'] = tokenResponse.apiKey;
    headers['Accept'] = 'application/json';
    print('$baseUrl/api/CheckUser');
    final response =
        await this.httpClient.get('$baseUrl/api/CheckUser', headers: headers);
    var res = _responseMap(response);
    if (res['status'] == 401) {
      var prefs = PreferencesRepository();
      var credentials = CredentialModel(
          userName: (await prefs.getLocalUser()).name,
          password: await prefs.getPassword());
      res = await getToken(credentials);
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>> getProduct(
      {String code, String debit, SearchType searchType, int page}) async {
    Map<String, String> headers = new Map<String, String>();
    TokenResponseModel tokenResponse = await getLocalToken();
    headers['Authorization'] = tokenResponse.apiKey;
    headers['Accept'] = 'application/json';
    var url = searchType == SearchType.BY_CODE
        ? 'ProductByCode?cod=$code&debit=$debit&page=$page'
        : 'ProductByName?name=$code&debit=$debit&page=$page';
    print('$baseUrl/api/$url');
    final response =
        await this.httpClient.get('$baseUrl/api/$url', headers: headers);
    var res = _responseMap(response);
    if (res['status'] == 401) {
      var prefs = PreferencesRepository();
      var credentials = CredentialModel(
          userName: (await prefs.getLocalUser()).name,
          password: await prefs.getPassword());
      res = await getToken(credentials);
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>> getLastInputDate(
      {int code, String debit}) async {
    var url = '$baseUrl/api/LastInputDate?cod=${code.toString()}&debit=$debit';
    Map<String, String> headers = new Map<String, String>();
    TokenResponseModel tokenResponse = await getLocalToken();
    headers['Authorization'] = tokenResponse.apiKey;
    headers['Accept'] = 'application/json';
    print('$url');
    final response = await this.httpClient.get('$url', headers: headers);
    var res = _responseMap(response);
    if (res['status'] == 401) {
      var prefs = PreferencesRepository();
      var credentials = CredentialModel(
          userName: (await prefs.getLocalUser()).name,
          password: await prefs.getPassword());
      res = await getToken(credentials);
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>> getSalesInPeriod(
      {int code, String debit, String startDate, String endDate}) async {
    var url =
        '$baseUrl/api/ProductSalesInPeriod?cod=${code.toString()}&debit=$debit&startDate=$startDate&endDate=$endDate';
    Map<String, String> headers = new Map<String, String>();
    TokenResponseModel tokenResponse = await getLocalToken();
    headers['Authorization'] = tokenResponse.apiKey;
    headers['Accept'] = 'application/json';
    print('$url');
    final response = await this.httpClient.get('$url', headers: headers);
    var res = _responseMap(response);
    if (res['status'] == 401) {
      var prefs = PreferencesRepository();
      var credentials = CredentialModel(
          userName: (await prefs.getLocalUser()).name,
          password: await prefs.getPassword());
      res = await getToken(credentials);
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>> getOrderByNumber(
      {String orderNumber, String repository}) async {
    var url =
        '$baseUrl/api/OrderByNumber?orderNumber=$orderNumber&location=$repository';
    Map<String, String> headers = new Map<String, String>();
    TokenResponseModel tokenResponse = await getLocalToken();
    headers['Authorization'] = tokenResponse.apiKey;
    headers['Accept'] = 'application/json';
    print('$url');
    final response = await this.httpClient.get('$url', headers: headers);
    var res = _responseMap(response);
    if (res['status'] == 401) {
      var prefs = PreferencesRepository();
      var credentials = CredentialModel(
          userName: (await prefs.getLocalUser()).name,
          password: await prefs.getPassword());
      res = await getToken(credentials);
    }
    return res;
  }

  @override
  Future<ApiResponse1<int>> getOrderCount(
      {String orderNumber, String repository}) {
    // TODO: implement getOrderCount
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getOrderItems(
      {String orderNumber, String repository}) async {
    var url =
        '$baseUrl/api/OrderItems?orderNumber=$orderNumber&location=$repository';
    Map<String, String> headers = new Map<String, String>();
    TokenResponseModel tokenResponse = await getLocalToken();
    headers['Authorization'] = tokenResponse.apiKey;
    headers['Accept'] = 'application/json';
    print('$url');
    final response = await this.httpClient.get('$url', headers: headers);

    var res = _responseMap(response);

    if (res['status'] == 401) {
      var prefs = PreferencesRepository();
      var credentials = CredentialModel(
          userName: (await prefs.getLocalUser()).name,
          password: await prefs.getPassword());
      res = await getToken(credentials);
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>> putIssue(
      {int code, String debit, int status, int userId}) async {
    var url = '$baseUrl/api/ProductWithIssue';
    Map<String, String> headers = new Map<String, String>();
    TokenResponseModel tokenResponse = await getLocalToken();
    headers['Authorization'] = tokenResponse.apiKey;
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';
    Map<String, dynamic> body = {
      "COD_PRODUS": code,
      "DEBIT": debit,
      "STATUS": status,
      "COD_USER": userId,
      "REZOLVAT": false
    };
    print('$url');
    final response = await this
        .httpClient
        .put('$url', headers: headers, body: jsonEncode(body));
    var res = _responseMap(response);
    if (res['status'] == 401) {
      var prefs = PreferencesRepository();
      var credentials = CredentialModel(
          userName: (await prefs.getLocalUser()).name,
          password: await prefs.getPassword());
      res = await getToken(credentials);
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>> getProductDetails(
      {int code, String debit}) async {
    var url = '$baseUrl/api/ProductDetails?cod=${code.toString()}&debit=$debit';
    Map<String, String> headers = new Map<String, String>();
    TokenResponseModel tokenResponse = await getLocalToken();
    headers['Authorization'] = tokenResponse.apiKey;
    headers['Accept'] = 'application/json';
    print('$url');
    final response = await this.httpClient.get('$url', headers: headers);
    var res = _responseMap(response);
    if (res['status'] == 401) {
      var prefs = PreferencesRepository();
      var credentials = CredentialModel(
          userName: (await prefs.getLocalUser()).name,
          password: await prefs.getPassword());
      res = await getToken(credentials);
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>> getToken(CredentialModel credentials) async {
    // TokenResponseModel token = await PreferencesRepository().getLocalToken();
    var url =
        '$baseUrl/login?user=${credentials.userName}&password=${credentials.password}';
    print(url);
    final response = await this
        .httpClient
        .post(
            '$baseUrl/login?user=${credentials.userName}&password=${credentials.password}')
        .timeout(
            Duration(
              seconds: 10,
            ), onTimeout: () {
      return null;
    });

    return _responseMap(response);
  }

  Map<String, dynamic> _responseMap(http.Response response) {
    if (response == null) {
      throw ApiException('Connection timeout');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      if (response.statusCode == 403 && response.body.isNotEmpty) {
        try {
          Map<String, dynamic> jsonError = json.decode(response.body);
          String message = jsonError['message'] as String;
          String addedBy = jsonError['addedBy'] as String;
          throw ApiException(
              '${message == 'Produs deja existent' ? '$message adaugat de $addedBy' : message}');
        } on FormatException catch (_) {
          throw ApiException(
              'code: ${response.statusCode.toString()}, message ${response.reasonPhrase}');
        }
      }
      if (response.body.isNotEmpty) {
        if (response.statusCode == 401) {
          return {"status": 401};
        }
        try {
          Map<String, dynamic> jsonError = json.decode(response.body);
          String message = jsonError['message'] as String;
          throw ApiException(message);
        } on FormatException catch (_) {
          throw ApiException(
              'code: ${response.statusCode.toString()}, message ${response.reasonPhrase}');
        }
      } else
        throw ApiException('Error fetching data');
    }

    final Map<String, dynamic> responseJson = json.decode(response.body);
    return responseJson;
  }
}

class ApiException implements Exception {
  final message;

  ApiException([this.message]);

  @override
  String toString() {
    return '$message';
  }
}
