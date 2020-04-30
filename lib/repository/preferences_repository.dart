import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/repository/local_base_repository.dart';
import 'package:pacointro/utils/constants.dart';

class PreferencesRepository extends LocalBaseRepository {
  Future<UserModel> getLocalUser() async {
    var map = await super.getLocalObject(key: userKey);
    if (map == null) return null;
    return UserModel.fromMap(map);
  }

  Future<bool> saveLocalUser({UserModel user}) async {
    return await super.saveLocalObject(map: user.toJson(), key: userKey);
  }

  Future<LocationModel> getLocalLocation() async {
    var map = await super.getLocalObject(key: currentLocationKey);
    if (map == null) return null;
    return LocationModel.fromMap(map);
  }

  Future<bool> saveLocalLocation({LocationModel location}) async {
    return await super
        .saveLocalObject(map: location.toJson(), key: currentLocationKey);
  }
}
