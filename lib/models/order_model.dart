import 'package:intl/intl.dart';
import 'package:pacointro/models/invoice_model.dart';

class OrderModel {
  int id;
  int orderNumber;
  DateTime orderDate;
  String supplierFiscalCode;
  String supplierName;
  int productsCount;
  List<InvoiceModel> invoices;

  OrderModel(
      {this.id,
      this.orderNumber,
      this.orderDate,
      this.supplierFiscalCode,
      this.supplierName,
      this.productsCount,
      this.invoices = const []});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['orderDate'] = this.orderDate.millisecondsSinceEpoch;
    data['supplierFiscalCode'] = this.supplierFiscalCode.toString();
    data['supplierName'] = this.supplierName;
    data['productsCount'] = this.productsCount;
    data['invoices'] = this.invoices;
    return data;
  }

  Map<String, dynamic> toAPIJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['invoices'] = this.invoices.map((e) => e.toAPIJson()).toList();
    // data['invoiceNumber'] = this.invoice.invoiceNumber;
    // data['invoiceDate'] = this.invoice.invoiceDate.toLocal().toIso8601String().replaceAll('T', " ");
    return data;
  }

  factory OrderModel.fromPreferences(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['orderNumber'],
      orderDate: DateTime.fromMillisecondsSinceEpoch(json['orderDate']),
      supplierName: json['supplierName'],
      supplierFiscalCode: json['supplierFiscalCode'].toString(),
      productsCount: json['productsCount'],
      invoices: json['invoices']
          .map<InvoiceModel>((e) => InvoiceModel.fromMap(e))
          .toList(),
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
        id: json["ID"],
        orderNumber: json["NUMARCOMANDA"],
        supplierName: json["FURNIZOR"],
        orderDate: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["DATA"]),
        supplierFiscalCode: json["COD_FISCAL"].toString(),
        productsCount: json["TOTAL_PRODUSE"]);
  }

  String get orderDateString => DateFormat('dd.MM.yyyy').format(orderDate);

  int get nextAvailableInvoiceId =>
      invoices.fold(
          invoices.isEmpty ? 0 : invoices[0].id,
          (previousValue, element) =>
              previousValue < element.id ? element.id : previousValue) +
      1;

  int get currentInvoiceId {
    var inv = invoices.where((element) => element.isCurrent).toList();
    return inv.isEmpty ? null : inv[0].id;
  }

}
