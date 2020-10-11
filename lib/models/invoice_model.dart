import 'package:intl/intl.dart';

class InvoiceModel {
  String invoiceNumber;
  DateTime invoiceDate;

  InvoiceModel({
    this.invoiceNumber,
    this.invoiceDate,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['invoiceNumber'] = this.invoiceNumber;
    data['invoiceDate'] = this.invoiceDate.toIso8601String();
    // data['orderDate'] =
    //     DateFormat('MM/dd/yyyy hh:mm:ss a').format(this.orderDate);
    return data;
  }

  String get invoiceDateString => DateFormat('dd.MM.yyyy').format(invoiceDate);
  bool get isValid => invoiceNumber != null && invoiceDate != null;
}
