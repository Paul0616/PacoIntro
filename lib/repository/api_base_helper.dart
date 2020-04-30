import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:pacointro/repository/api_exceptions.dart';

class ApiBaseHelper {
  Future<dynamic> get(String url) async {
    print('[GET], $url');
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Nu există conexiune la Internet');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    print('[POST], $url'); // body: ${body.toString()}');
    var responseJson;
    try {
      final response = await http.post(url, body: jsonEncode(body));
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('Nu există conexiune la Internet');
    }
    return responseJson;
  }
}

dynamic _returnResponse(http.Response response) {
  //print(response.statusCode);

  switch (response.statusCode) {
    case 200:
      //dynamic result;
      if (response.body == '') return null;
      try {
        return json.decode(response.body.toString());
      } catch (e) {
        return response.body.toString();
      }
      break;

    case 400:
      throw BadRequestException(
          '${response.statusCode} - ${json.decode(response.body.toString())}');
      break;
    case 477:
      throw UnauthorisedException('${response.statusCode} - Eroare Client');
      break;
    case 401:
      throw UnauthorisedException(
          '${response.statusCode} - Acest user nu mai este autorizat!');
      break;
    case 404:
      throw NotFoundException(
          '${response.statusCode} - ${response.body.toString()}');
      break;
    case 500:
      break;
    default:
      throw FetchDataException('${response.statusCode}');
  }
}
