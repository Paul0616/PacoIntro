import 'package:pacointro/models/base_model.dart';
import 'package:pacointro/models/location_model.dart';

class UserModel extends BaseModel {
  List<LocationModel> locations;

  UserModel({int id, String name, this.locations}) : super(id: id, name: name);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['LOCATII'] = this.locations;
    return data;
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    var iterableLocations = json["LOCATII"];
    List<Map<String, dynamic>> locationsMap =
        List<Map<String, dynamic>>.from(iterableLocations);
    return UserModel(
        id: json["ID"],
        name: json["NUME UTILIZATOR"],
        locations:
            locationsMap.map((map) => LocationModel.fromMap(map)).toList());
  }
}
