import 'package:pacointro/models/base_model.dart';

class ProductModel extends BaseModel {
  double price;
  String measureUnit;
  double quantity;
  int createdAt = DateTime.now().millisecondsSinceEpoch;

  ProductModel(
      {int id,
      this.price,
      this.measureUnit,
      this.quantity,
      this.createdAt,
      String name})
      : super(id: id, name: name);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['price'] = this.price;
    data['measureUnit'] = this.measureUnit;
    return data;
  }

  Map<String, dynamic> toDatabaseMap(bool isInOrder) {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['measureUnit'] = this.measureUnit;
    data['isInOrder'] = isInOrder ? 1 : 0;
    data['createdAt'] = this.createdAt;
    return data;
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    // double q = json["quantity"].toDouble();
    return ProductModel(
        id: json["code"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"].toDouble(),
        measureUnit: json["measureUnit"],
        createdAt: json['createdAt']);
  }
}
