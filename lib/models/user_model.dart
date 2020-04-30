import 'package:pacointro/models/base_model.dart';
import 'package:pacointro/models/location_model.dart';

class UserModel extends BaseModel {
  List<LocationModel> locations;

  UserModel({int id, String name, this.locations}) : super(id: id, name: name);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['locations'] = this.locations;
    return data;
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    var iterableLocations = json["locations"];
    List<Map<String, dynamic>> locationsMap =
        List<Map<String, dynamic>>.from(iterableLocations);
    return UserModel(
        id: json["id"],
        name: json["name"],
        locations:
            locationsMap.map((map) => LocationModel.fromMap(map)).toList());
  }
}
