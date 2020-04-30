import 'package:pacointro/models/base_model.dart';

class LocationModel extends BaseModel {
  double fiscalCode;
  String debit;

  LocationModel({int id, this.fiscalCode, this.debit, String name})
      : super(id: id, name: name);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['fiscalCode'] = this.fiscalCode;
    data['debit'] = this.debit;
    return data;
  }

  factory LocationModel.fromMap(Map<String, dynamic> json) {
    return LocationModel(
        id: json["id"],
        name: json["name"],
        fiscalCode: json["locations"],
        debit: json["debit"]);
  }
}
