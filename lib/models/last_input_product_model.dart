import 'package:pacointro/models/base_model.dart';

class LastInputProductModel extends BaseModel {
  DateTime lastInputDate;

  LastInputProductModel({int id, this.lastInputDate, String name})
      : super(id: id, name: name);

  factory LastInputProductModel.fromMap(Map<String, dynamic> json) {
    return LastInputProductModel(
      id: (json["COD"] is int) ? json["COD"] : int.parse(json["COD"]),
      name: json["DENUMIRE"],
      lastInputDate: DateTime.tryParse(json['LASTINPUTDATE']),
    );
  }
}
