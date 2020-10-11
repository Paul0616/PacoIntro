import 'package:pacointro/models/base_model.dart';

class SalesProductModel extends BaseModel {
  double sales;
  String measureUnit;
  DateTime startIntervalStockDate;
  DateTime endIntervalStockDate;

  SalesProductModel(
      {int id,
      this.sales,
      this.measureUnit,
      this.startIntervalStockDate,
      this.endIntervalStockDate,
      String name})
      : super(code: id, name: name);

  factory SalesProductModel.fromMap(Map<String, dynamic> json) {
    return SalesProductModel(
        id: json["COD"],
        name: json["DENUMIRE"],
        sales: json["CANTITATE"].toDouble(),
        measureUnit: json["UM"],
        startIntervalStockDate: json['startIntervalStockDate'] != null
            ? DateTime.tryParse(json['startIntervalStockDate'])
            : null,
        endIntervalStockDate: json['endIntervalStockDate'] != null
            ? DateTime.tryParse(json['endIntervalStockDate'])
            : null);
  }
}
