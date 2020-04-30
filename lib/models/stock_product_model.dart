import 'package:pacointro/models/base_model.dart';

class StockProductModel extends BaseModel {
  double stock;
  DateTime stockDate;
  String measureUnit;

  StockProductModel(
      {int id, this.stock, this.stockDate, this.measureUnit, String name})
      : super(id: id, name: name);

  factory StockProductModel.fromMap(Map<String, dynamic> json) {
    return StockProductModel(
      id: json["code"],
      name: json["name"],
      stock: json["stock"],
      measureUnit: json["measureUnit"],
      stockDate: DateTime.tryParse(json['stockDate']),
    );
  }
}
