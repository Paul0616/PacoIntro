import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/token_response_model.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/repository/local_base_repository.dart';
import 'package:pacointro/utils/constants.dart';

class PreferencesRepository extends LocalBaseRepository {
  Future<TokenResponseModel> getLocalToken() async {
    var map = await super.getLocalObjectMap(key: tokenKey);
    if (map == null) return null;
    return TokenResponseModel.fromMap(map);
  }

  Future<bool> saveLocalToken({TokenResponseModel token}) async {
    return await super.saveLocalObjectMap(map: token.toJson(), key: tokenKey);
  }

  Future<UserModel> getLocalUser() async {
    var map = await super.getLocalObjectMap(key: userKey);
    if (map == null) return null;
    return UserModel.fromMap(map);
  }

  Future<bool> saveLocalUser({UserModel user}) async {
    return await super.saveLocalObjectMap(map: user.toJson(), key: userKey);
  }

  Future<bool> savePassword(String password) async {
    final prefs = await super.prefs;
    return await prefs.setString(passwordKey, password);
  }

  Future<String> getPassword() async {
    final prefs = await super.prefs;
    return prefs.getString(passwordKey);
  }

  Future<LocationModel> getLocalLocation() async {
    var map = await super.getLocalObjectMap(key: currentLocationKey);
    if (map == null) return null;
    return LocationModel.fromMap(map);
  }

  Future<bool> saveLocalLocation({LocationModel location}) async {
    return await super
        .saveLocalObjectMap(map: location.toJson(), key: currentLocationKey);
  }

//  Future<OrderModel> getLocalCurrentOrder() async {
//    var map = await super.getLocalObjectMap(key: orderCountKey);
//    if (map == null) return null;
//    return OrderModel.fromMap(map);
//  }
//
//  Future<bool> saveLocalCurrentOrder({OrderModel order}) async {
//    return await super
//        .saveLocalObjectMap(map: order.toJson(), key: orderCountKey);
//  }
}
