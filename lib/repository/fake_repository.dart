import 'dart:convert';

import 'package:pacointro/data/fake_data.dart';
import 'package:pacointro/models/credentials_model.dart';
import 'package:pacointro/models/last_input_product_model.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/sales_product_model.dart';
import 'package:pacointro/models/stock_product_model.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'package:pacointro/repository/repository_interface.dart';

class FakeRepository extends PreferencesRepository implements DataSource {
  @override
  void dispose() {}

  @override
  Future<ApiResponse<UserModel>> checkUsers(CredentialModel credentials) async {
    return await Future.delayed(Duration(seconds: 1), () {
      List userList = JsonDecoder().convert(fakeUsers);
      UserModel foundedUser;
      userList.forEach((map) {
        UserModel user = UserModel.fromMap(map);
        if (credentials.userName == user.name) {
          foundedUser = user;
        }
      });
      return foundedUser == null
          ? ApiResponse.error('User sau parola greșite.')
          : ApiResponse.completed(foundedUser);
    });
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getProduct(
      {String code, String debit, bool searchByName = false}) async {
    return await Future.delayed(Duration(milliseconds: 800), () {
      List productList = JsonDecoder().convert(products);
      List<ProductModel> foundedProducts = List<ProductModel>();
      productList.forEach((map) {
        ProductModel product = ProductModel.fromMap(map);
        if (searchByName) {
          if (product.name.toUpperCase().contains(code.toUpperCase()))
            foundedProducts.add(product);
        } else {
          int _code = int.tryParse(code);
          if (_code != null && _code == product.id)
            foundedProducts.add(product);
        }
      });
      return foundedProducts.isEmpty
          ? ApiResponse.error('N-am găsit nici un produs.')
          : ApiResponse.completed(foundedProducts);
    });
  }

  @override
  Future<ApiResponse<StockProductModel>> getStockAndDate(
      {String code, String debit}) async {
    return await Future.delayed(Duration(milliseconds: 1000), () {
      StockProductModel stock =
          StockProductModel.fromMap(JsonDecoder().convert(stockAtDate));
      print("--------->STOCK ${stock.stockDate.toIso8601String()}");
      //return ApiResponse.error("Stock error");
      return ApiResponse.completed(stock);
    });
  }

  @override
  Future<ApiResponse<LastInputProductModel>> getLastInputDate(
      {String code, String debit}) async {
    return await Future.delayed(Duration(milliseconds: 800), () {
      LastInputProductModel lastInput =
          LastInputProductModel.fromMap(JsonDecoder().convert(lastInputDate));
      print(
          "--------->LAST INPUT ${lastInput.lastInputDate.toIso8601String()}");
      //return ApiResponse.error("Last input error");
      return ApiResponse.completed(lastInput);
    });
  }

  @override
  Future<ApiResponse<SalesProductModel>> getSalesInPeriod(
      {String code, String debit, DateTime startDate, DateTime endDate}) async {
    return await Future.delayed(Duration(milliseconds: 1100), () {
      SalesProductModel sales =
          SalesProductModel.fromMap(JsonDecoder().convert(salesBetweenDates));
      sales.startIntervalStockDate = startDate;
      sales.endIntervalStockDate = endDate;
      print("--------->SALES ${sales.sales.toString()}");
      //return ApiResponse.error("Sales in period error");
      return ApiResponse.completed(sales);
    });
  }

  @override
  Future<ApiResponse<OrderModel>> getOrderByNumber(
      {String orderNumber, String repository}) async {
    return await Future.delayed(Duration(milliseconds: 900), () {
      OrderModel orderModel = OrderModel.fromMap(JsonDecoder().convert(order));
      return ApiResponse.completed(orderModel);
    });
  }

  @override
  Future<ApiResponse<int>> getOrderCount(
      {int orderNumber, String repository}) async {
    return await Future.delayed(Duration(milliseconds: 1000), () {
      List items = JsonDecoder().convert(orderItems);
      List<ProductModel> foundedProducts = List<ProductModel>();
      items.forEach((map) {
        ProductModel product = ProductModel.fromMap(map);
        foundedProducts.add(product);
      });
      return ApiResponse.completed(foundedProducts.length);
    });
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getOrderItems(
      {int orderNumber, String repository}) {
    // TODO: implement getOrderItems
    throw UnimplementedError();
  }
}
