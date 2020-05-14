import 'package:pacointro/models/base_model.dart';

class ProductModel extends BaseModel {
  double price;
  String measureUnit;
  double quantity;

  ProductModel({int id, this.price, this.measureUnit, this.quantity, String name})
      : super(id: id, name: name);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['price'] = this.price;
    data['measureUnit'] = this.measureUnit;
    return data;
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
   // double q = json["quantity"].toDouble();
    return ProductModel(
        id: json["code"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"].toDouble(),
        measureUnit: json["measureUnit"]);

  }
}
