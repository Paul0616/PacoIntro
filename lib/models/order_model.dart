import 'package:intl/intl.dart';
import 'package:pacointro/models/invoice_model.dart';

class OrderModel {
  int id;
  int orderNumber;
  DateTime orderDate;
  int supplierFiscalCode;
  String supplierName;
  int productsCount;
  InvoiceModel invoice;

  OrderModel(
      {this.id,
      this.orderNumber,
      this.orderDate,
      this.supplierFiscalCode,
      this.supplierName,
      this.productsCount,
      this.invoice});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['orderDate'] = this.orderDate.millisecondsSinceEpoch;
    data['supplierFiscalCode'] = this.supplierFiscalCode;
    data['supplierName'] = this.supplierName;
    data['productsCount'] = this.productsCount;
    data['invoice'] = this.invoice.toJson();
    return data;
  }

  factory OrderModel.fromPreferences(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['orderNumber'],
      orderDate: DateTime.fromMillisecondsSinceEpoch(json['orderDate']),
      supplierName: json['supplierName'],
      supplierFiscalCode: json['supplierFiscalCode'],
      productsCount: json['productsCount'],
      invoice: InvoiceModel.fromMap(json['invoice']),
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
        id: json["ID"],
        orderNumber: json["NUMARCOMANDA"],
        supplierName: json["FURNIZOR"],
        orderDate: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["DATA"]),
        supplierFiscalCode: json["COD_FISCAL"],
        productsCount: json["TOTAL_PRODUSE"]);
  }

  String get orderDateString => DateFormat('dd.MM.yyyy').format(orderDate);
}
