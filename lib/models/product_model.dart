import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/base_model.dart';

class ProductModel extends BaseModel {
  int id;
  double price;
  double secondPrice;
  double quantityWhereSecondPriceIsValidFor;
  String measureUnit;
  double quantity;
  bool belongsToOrder;
  int invoiceId;
  ProductType productType;
  int createdAt;

  ProductModel(
      {this.id,
      int code,
      this.price,
      this.secondPrice,
      this.quantityWhereSecondPriceIsValidFor,
      this.measureUnit,
      this.quantity,
      this.belongsToOrder,
      this.productType,
      this.invoiceId,
      this.createdAt,
      String name})
      : super(code: code, name: name);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['price'] = this.price;
    data['measureUnit'] = this.measureUnit;
    return data;
  }

  Map<String, dynamic> toDatabaseMap({ProductType productType, bool isInsert = true}) {
    Map<String, dynamic> data = Map<String, dynamic>();
    if (this.id != null) data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['measureUnit'] = this.measureUnit;
    data['productType'] = productType == ProductType.ORDER ? 1 : 0;
    data['belongsToOrder'] = this.belongsToOrder ? 1 : 0;
    data['invoiceId'] = this.invoiceId;
    var dateInt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    data['createdAt'] = isInsert ? dateInt : this.createdAt;
    return data;
  }

  factory ProductModel.fromDatabase(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      code: json["code"],
      name: json["name"],
      price: (json["price"] ?? 0).toDouble(),
      quantity: json["quantity"] ?? 0,
      measureUnit: json["measureUnit"],
      belongsToOrder: json["belongsToOrder"] == 1,
      invoiceId: json["invoiceId"],
      productType:
          json['productType'] == 1 ? ProductType.ORDER : ProductType.RECEPTION,
      createdAt: json["createdAt"]
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    // double q = json["quantity"].toDouble();

    return ProductModel(
      code: json["COD"],
      name: json["DENUMIRE"],
      price: (json["PRET"] ?? 0).toDouble(),
      quantity: json["CANTITATE"] ?? 0,
      secondPrice: json["PRET2"]?.toDouble(),
      quantityWhereSecondPriceIsValidFor: json["CANTITATE2"]?.toDouble(),
      measureUnit: json["UM"],
      belongsToOrder: json["belongsToOrder"] == 1,
      productType:
          json['productType'] == 1 ? ProductType.ORDER : ProductType.RECEPTION,
      createdAt:  json["createdAt"]
    );
  }
}
