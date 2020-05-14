import 'package:intl/intl.dart';

class OrderModel {
  int id;
  int orderNumber;
  DateTime orderDate;
  double supplierFiscalCode;
  String supplierName;
  int productsCount;

  OrderModel(
      {this.id,
      this.orderNumber,
      this.orderDate,
      this.supplierFiscalCode,
      this.supplierName});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['orderDate'] =
        DateFormat('MM/dd/yyyy hh:mm:ss a').format(this.orderDate);
    data['supplierFiscalCode'] = this.supplierFiscalCode;
    data['supplierName'] = this.supplierName;
    data['productsCount'] = this.productsCount;
    return data;
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
        id: json["id"],
        orderNumber: json["orderNumber"],
        supplierName: json["supplierName"],
        orderDate: DateFormat('MM/dd/yyyy hh:mm:ss a').parse(json["orderDate"]),
        supplierFiscalCode: json["supplierFiscalCode"]);
  }

  String get orderDateString => DateFormat('dd.MM.yyyy').format(orderDate);
}
