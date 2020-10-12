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
    data['invoiceDate'] = this.invoiceDate.millisecondsSinceEpoch;
    // data['orderDate'] =
    //     DateFormat('MM/dd/yyyy hh:mm:ss a').format(this.orderDate);
    return data;
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceNumber: json["invoiceNumber"],
      invoiceDate: DateTime.fromMillisecondsSinceEpoch(json["invoiceDate"]),
    );
  }

  String get invoiceDateString => DateFormat('dd.MM.yyyy').format(invoiceDate);

  bool get isValid => invoiceNumber != null && invoiceDate != null;
}
