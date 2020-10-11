import 'package:pacointro/models/base_model.dart';

class StockProductModel extends BaseModel {
  double stock;
  DateTime stockDate;
  String measureUnit;

  StockProductModel(
      {int id, this.stock, this.stockDate, this.measureUnit, String name})
      : super(code: id, name: name);

  factory StockProductModel.fromMap(Map<String, dynamic> json) {
    return StockProductModel(
      id: json["COD"],
      name: json["DENUMIRE"],
      stock: json["CANTITATE"].toDouble(),
      measureUnit: json["UM"],
      stockDate: DateTime.tryParse(json['DATA_STOC']),
    );
  }
}
