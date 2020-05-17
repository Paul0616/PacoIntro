import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/base_model.dart';

class ProductModel extends BaseModel {
  double price;
  String measureUnit;
  double quantity;
  bool belongsToOrder;
  ProductType productType;
  int createdAt = DateTime.now().millisecondsSinceEpoch;

  ProductModel(
      {int id,
      this.price,
      this.measureUnit,
      this.quantity,
      this.belongsToOrder,
      this.productType,
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

  Map<String, dynamic> toDatabaseMap(
      {ProductType productType}) {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['measureUnit'] = this.measureUnit;
    data['productType'] = productType == ProductType.ORDER ? 1 : 0;
    data['belongsToOrder'] = this.belongsToOrder ? 1 : 0;
    data['createdAt'] = this.createdAt;
    return data;
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    // double q = json["quantity"].toDouble();
    return ProductModel(
        id: json["code"],
        name: json["name"],
        price: json["price"],
        quantity: (json["quantity"] ?? 0).toDouble(),
        measureUnit: json["measureUnit"],
        belongsToOrder: json["belongsToOrder"] == 1,
        productType: json['productType'] == 1 ? ProductType.ORDER : ProductType.RECEPTION,
        createdAt: json['createdAt']);
  }
}
