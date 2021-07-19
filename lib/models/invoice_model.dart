import 'package:intl/intl.dart';

class InvoiceModel {
  int id;
  String invoiceNumber;
  DateTime invoiceDate;
  bool isCurrent;

  InvoiceModel({
    this.id,
    this.invoiceNumber,
    this.invoiceDate,
    this.isCurrent
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['invoiceNumber'] = this.invoiceNumber;
    data['invoiceDateMillis'] = this.invoiceDate.millisecondsSinceEpoch;
    data['isCurrent'] = this.isCurrent;
    return data;
  }

  Map<String, dynamic> toAPIJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['invoiceNumber'] = this.invoiceNumber;
    data['invoiceDate'] = this.invoiceDate.toIso8601String().replaceAll('T', " ");
    return data;
  }


  factory InvoiceModel.fromMap(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json["id"],
      invoiceNumber: json["invoiceNumber"],
      invoiceDate: DateTime.fromMillisecondsSinceEpoch(json["invoiceDateMillis"]),
      isCurrent: json['isCurrent'],
    );
  }

  String get invoiceDateString => DateFormat('dd.MM.yyyy').format(invoiceDate);

  bool get isValid => invoiceNumber != null && invoiceDate != null;

}
