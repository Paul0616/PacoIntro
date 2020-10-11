import 'package:pacointro/models/base_model.dart';

class LocationModel extends BaseModel {
  double fiscalCode;
  String debit;

  LocationModel({int id, this.fiscalCode, this.debit, String name})
      : super(id: id, name: name);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['ID'] = this.id;
    data['NUME GESTIUNE'] = this.name;
    data['COD FISCAL'] = this.fiscalCode;
    data['DEBIT'] = this.debit;
    return data;
  }

  factory LocationModel.fromMap(Map<String, dynamic> json) {
    return LocationModel(
        id: json["ID"],
        name: json["NUME GESTIUNE"],
        fiscalCode: json["COD FISCAL"],
        debit: json["DEBIT"].toString());
  }
}
