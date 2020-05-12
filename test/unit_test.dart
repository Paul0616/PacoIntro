import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pacointro/models/order_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Test ServerConnectionModel', () async {
//    ServerConnectionModel serverConnectionModel = ServerConnectionModel(
//        baseUrl: demoBaseUrl, apiKey: demoApiKey);
//    SharedPreferences.setMockInitialValues({});
//    var prefs = await SharedPreferences.getInstance();
//    prefs.setString('connectionServer',
//        JsonEncoder().convert(serverConnectionModel.toJson()));
//
//    var result = JsonDecoder().convert(
//        prefs.getString('connectionServer')) as Map<String, dynamic>;
//
//    expect(result['baseUrl'], demoBaseUrl);
//    expect(result['apiKey'], demoApiKey);
    const String order = '{"id":28707, "orderNumber":11123, "orderDate": "4/16/2020 1:33:32 PM", "supplierFiscalCode": 11885854.2, "supplierName": "PROGRES DISTRIBUTIE SRL - BAUTURI"}';
    var orderModel = OrderModel.fromMap(JsonDecoder().convert(order));
    expect(orderModel.id, 28707);
    expect(orderModel.orderNumber, 11123);
    expect(orderModel.orderDate.day, 16);
    expect(orderModel.supplierFiscalCode, 11885854.2);
    expect(orderModel.supplierName, "PROGRES DISTRIBUTIE SRL - BAUTURI");
  }, skip: false);
}