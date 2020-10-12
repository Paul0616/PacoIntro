import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pacointro/models/invoice_model.dart';
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
    OrderModel order = OrderModel(
        id: 28707,
        orderNumber: 11123,
        orderDate: DateTime.now().subtract(Duration(minutes: 75)),
        supplierFiscalCode: 11885854,
        supplierName: "PROGRES DISTRIBUTIE SRL - BAUTURI",
        productsCount: 8,
        invoice:
            InvoiceModel(invoiceNumber: '342342', invoiceDate: DateTime.now()));
    //var orderModel = OrderModel.fromPreferences(JsonDecoder().convert(order));
    String orderString = JsonEncoder().convert(order.toJson());
    var ord = OrderModel.fromPreferences(JsonDecoder().convert(orderString));
    expect(ord.id, 28707);
    expect(ord.orderNumber, 11123);
    expect(ord.orderDate.day, 12);
    expect(ord.supplierFiscalCode, 11885854.2);
    expect(ord.supplierName, "PROGRES DISTRIBUTIE SRL - BAUTURI");
    expect(ord.productsCount, 8);
    expect(ord.invoice.invoiceNumber, '342342');
    expect(ord.invoice.invoiceDate.day, 12);
  }, skip: false);
}
