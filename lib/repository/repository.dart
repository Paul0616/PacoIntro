import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:pacointro/models/credentials_model.dart';
import 'package:pacointro/models/token_response_model.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'package:pacointro/repository/repository_interface.dart';
import 'package:pacointro/utils/constants.dart';

class Repository extends PreferencesRepository implements DataSource {
  final http.Client httpClient;
  //final HttpClient httpClient;
  final String baseUrl = 'https://api-paco.bavial.ro';

  @override
  void dispose() {}


//   void main() {
//     const sslUrl = 'https://valid-isrgrootx1.letsencrypt.org/';
//     /// From dart:io, create a HttpClient with a trusted certificate [cert]
//     /// added to SecurityContext.
//     /// Wrapped in try catch in case the certificate is already trusted by
//     /// device/os, which will cause an exception to be thrown.
//     static HttpClient customHttpClient({String cert}) {
//       SecurityContext context = SecurityContext.defaultContext;
//       try {
//         if (cert != null) {
//           Uint8List bytes = utf8.encode(cert);
//           context.setTrustedCertificatesBytes(bytes);
//         }
//         print('createHttpClient() - cert added!');
//       } on TlsException catch (e) {
//         if (e?.osError?.message != null &&
//             e.osError.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
//           print('createHttpClient() - cert already trusted! Skipping.');
//         }
//         else {
//           print('createHttpClient().setTrustedCertificateBytes EXCEPTION: $e');
//           rethrow;
//         }
//       } finally {}
//       HttpClient httpClient = new HttpClient(context: context);
//       return httpClient;
//     }
//     /// Use package:http Client with our custom dart:io HttpClient with added
//     /// LetsEncrypt trusted certificate
//     static http.Client createLEClient() {
//       IOClient ioClient;
//       ioClient = IOClient(customHttpClient(cert: ISRG_X1));
//       return ioClient;
//     }
//
//     /// Example using a custom package:http Client
//     /// that will work with devices missing LetsEncrypt
//     /// ISRG Root X1 certificates, like old Android 7 devices.
//     test('HTTP client to LetsEncrypt SSL website', () async {
//       http.Client _client = createLEClient();
//       http.Response _response = await _client.get(sslUrl);
//       print(_response.body);
//       expect(_response.statusCode, 200);
//     });
//   }
//
//   static const String ISRG_X1 = """-----BEGIN CERTIFICATE-----
// MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
// TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
// cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
// WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
// ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
// MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
// h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
// 0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
// A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
// T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
// B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
// B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
// KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
// OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
// jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
// qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
// rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
// HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
// hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
// ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
// 3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
// NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
// ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
// TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
// jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
// oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
// 4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
// mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
// emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
// -----END CERTIFICATE-----""";

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
  Future<int> getOrderCount({String orderNumber, String repository}) {
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
  Future<Map<String, dynamic>> postReception(Map<String, dynamic> body) async {
    var url = '$baseUrl/api/PostReception';
    prettyPrintJson(body);
    Map<String, String> headers = new Map<String, String>();
    TokenResponseModel tokenResponse = await getLocalToken();
    headers['Authorization'] = tokenResponse.apiKey;
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';
    print('$url');
    final response = await this
        .httpClient
        .post('$url', headers: headers, body: jsonEncode(body));
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

  static void prettyPrintJson(Map<String, dynamic> map){
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    var prettyString = encoder.convert(map);
    prettyString.split('\n').forEach((element) => print(element));
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

    final Map<String, dynamic> responseJson = response.body.isEmpty
        ? {"message": "succes"}
        : json.decode(response.body);
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
