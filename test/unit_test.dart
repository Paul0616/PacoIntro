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
        invoices:[
            InvoiceModel(id: 3, invoiceNumber: '342342', invoiceDate: DateTime.now()), InvoiceModel(id: 4, invoiceNumber: '342330', invoiceDate: DateTime.now().subtract(Duration(days: 1)))]);
    //var orderModel = OrderModel.fromPreferences(JsonDecoder().convert(order));
    print(order.nextAvailableInvoiceId);
    String orderString = JsonEncoder().convert(order.toJson());
    print(orderString);
    // print(DateTime.now().subtract(Duration(minutes: 75)).day);
    var ord = OrderModel.fromPreferences(JsonDecoder().convert(orderString));
    expect(ord.id, 28707);
    expect(ord.orderNumber, 11123);
    expect(ord.orderDate.day, DateTime.now().subtract(Duration(minutes: 75)).day);
    expect(ord.supplierFiscalCode, 11885854);
    expect(ord.supplierName, "PROGRES DISTRIBUTIE SRL - BAUTURI");
    expect(ord.productsCount, 8);
    expect(ord.invoices[0].invoiceNumber, '342342');
    expect(ord.invoices[1].invoiceDate.day, DateTime.now().subtract(Duration(days: 1)).day);
  }, skip: false);
}
