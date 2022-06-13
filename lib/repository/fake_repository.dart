import 'dart:convert';
import 'dart:math';

import 'package:pacointro/data/fake_data.dart';
import 'package:pacointro/models/credentials_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/token_response_model.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'package:pacointro/repository/repository_interface.dart';
import 'package:pacointro/utils/constants.dart';

import 'repository.dart';

class FakeRepository extends PreferencesRepository implements DataSource {
  @override
  void dispose() {}

  @override
  Future<Map<String, dynamic>> checkUser() async {
    Map<String, dynamic> response;
    await Future.delayed(Duration(milliseconds: 200), () async {
      TokenResponseModel tokenResponse = await getLocalToken();
      switch (tokenResponse.apiKey) {
        case "apiKeyPaul===":
          response = JsonDecoder().convert(fakeUser1);
          break;
        case "apiKeyTinel===":
          response = JsonDecoder().convert(fakeUser2);
          break;
        default:
          throw ApiException('User not found');
      }
    });
    return response;
  }

  @override
  Future<int> getOrderCount(
      {String orderNumber, String repository}) async {
    return await Future.delayed(Duration(milliseconds: 1000), () {
      List items = JsonDecoder().convert(orderItems);
      List<ProductModel> foundedProducts = <ProductModel>[];
      items.forEach((map) {
        ProductModel product = ProductModel.fromMap(map);
        foundedProducts.add(product);
      });
      return foundedProducts.length;
    });
  }

  @override
  Future<Map<String, dynamic>> getToken(CredentialModel credentials) async {
    await Future.delayed(Duration(milliseconds: 100), () {
      if (credentials.userName != 'paul' && credentials.userName != 'tinel') {
        throw ApiException('User not found');
      }
    });
    return credentials.userName == 'paul'
        ? {"message": "success", "apikey": "apiKeyPaul==="}
        : {"message": "success", "apikey": "apiKeyTinel==="};
  }

  @override
  Future<Map<String, dynamic>> getProduct(
      {String code, String debit, SearchType searchType, int page}) async {
    Map<String, dynamic> response;
    await Future.delayed(Duration(milliseconds: 300), () {
      if (searchType == SearchType.BY_NAME) {
        response = JsonDecoder().convert(products);
      } else {
        var allProducts = JsonDecoder().convert(products)['data'];
        var filtratedProducts = allProducts
            .where((element) => element['COD'].toString() == code)
            .toList();
        response = {
          "current_page": 1,
          "last_page": 1,
          "next_page_url": null,
          "data": filtratedProducts
        };
      }
    });
    return response;
  }

  @override
  Future<Map<String, dynamic>> putIssue(
      {int code, String debit, int status, int userId}) async {
    return await Future.delayed(Duration(milliseconds: 800), () {
      return {"isSucces": true};
    });
  }

  @override
  Future<Map<String, dynamic>> postReception(Map<String, dynamic> body) {
    // TODO: implement postReception
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getProductDetails(
      {int code, String debit}) async {
    Map<String, dynamic> response;
    await Future.delayed(Duration(milliseconds: 800), () {
      var allProducts = JsonDecoder().convert(products)['data'];
      var selectedProduct =
          allProducts.where((element) => element['COD'] == code).toList().first;
      response = selectedProduct;
      response['CANTITATE'] = Random().nextInt(130) + 20;
      response['DATA_STOC'] = DateTime.now().toLocal().toIso8601String();
    });
    return response;
  }

  @override
  Future<Map<String, dynamic>> getSalesInPeriod(
      {int code, String debit, String startDate, String endDate}) async {
    Map<String, dynamic> response;
    await Future.delayed(Duration(milliseconds: 500), () {
      var allProducts = JsonDecoder().convert(products)['data'];
      var selectedProduct =
          allProducts.where((element) => element['COD'] == code).toList().first;
      response = selectedProduct;
      response['CANTITATE'] = Random().nextInt(70);
      response['DATASTOC'] = DateTime.now().toLocal().toIso8601String();
    });
    return response;
  }

  @override
  Future<Map<String, dynamic>> getLastInputDate(
      {int code, String debit}) async {
    Map<String, dynamic> response;
    await Future.delayed(Duration(milliseconds: 400), () {
      var allProducts = JsonDecoder().convert(products)['data'];
      var selectedProduct =
          allProducts.where((element) => element['COD'] == code).toList().first;
      response = selectedProduct;

      response['LASTINPUTDATE'] = DateTime.now()
          .toLocal()
          .subtract(Duration(days: Random().nextInt(90)))
          .toIso8601String();
    });
    return response;
  }

  @override
  Future<Map<String, dynamic>> getOrderItems(
      {String orderNumber, String repository}) {
    // TODO: implement getOrderItems
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getOrderByNumber(
      {String orderNumber, String repository}) {
    // TODO: implement getOrderByNumber
    throw UnimplementedError();
  }
}
