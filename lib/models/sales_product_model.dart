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
      : super(id: id, name: name);

  factory SalesProductModel.fromMap(Map<String, dynamic> json) {
    return SalesProductModel(
        id: json["code"],
        name: json["name"],
        sales: json["sales"],
        measureUnit: json["measureUnit"],
        startIntervalStockDate:
            DateTime.tryParse(json['startIntervalStockDate']),
        endIntervalStockDate: DateTime.tryParse(json['endIntervalStockDate']));
  }
}
