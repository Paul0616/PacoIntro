import 'dart:async';

import 'package:pacointro/blocs/base_bloc.dart';
import 'package:pacointro/models/credentials_model.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/pages/home_page.dart';
import 'package:pacointro/pages/locations_page.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/repository/fake_repository.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc implements BaseBloc {
  final FakeRepository _repository;
  String _currentUser;
  CredentialModel _credentials = CredentialModel();

  LoginBloc.withRepository(this._repository) {
//    _currentUserController.stream.listen((response) {
//      if (response != null &&
//          response.status == Status.COMPLETED &&
//          response.data.name != null) {
//      }
//    });
    errorOccur.listen((hasError) => print('HAS ERROR: $hasError'));
    _userNameController.stream
        .listen((userName) => _credentials.userName = userName);
    _userNameController.stream.listen((userName) => print(userName));
    _passwordController.stream
        .listen((password) => _credentials.password = password);
    _passwordController.stream.listen((pass) => print(pass));
  }

  /* *******************************************************
    STREAMS
   ********************************************************/
  var _currentUserController = BehaviorSubject<ApiResponse<UserModel>>();
  var _localUserController = PublishSubject<String>();
  var _userNameController = BehaviorSubject<String>();
  var _passwordController = BehaviorSubject<String>();

  /* ---------------
  INPUT STREAMS
   -----------------*/

  Function(String) get userNameChanged => _userNameController.sink.add;

  Function(String) get passwordChanged => _passwordController.sink.add;

  /* *******************************************************
    OUTPUT
   ********************************************************/
  Stream<ApiResponse<UserModel>> get currentUserStream =>
      _currentUserController.stream;

  Stream<String> get userName => _userNameController.stream.transform(
        StreamTransformer<String, String>.fromHandlers(
          handleData: (userName, sink) {
            if (userName.length > 0) {
              sink.add(userName);
            } else {
              sink.addError("UserName should not be empty");
            }
          },
        ),
      );

  Stream<String> get localUser => _localUserController.stream;

  Stream<String> get password => _passwordController.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (password, sink) {
        if (password.length > 0) {
          sink.add(password);
        } else {
          sink.addError("Password length should not be empty");
        }
      }));

  Stream<bool> get submitCheck =>
      Rx.combineLatest2(userName, password, (e, p) => true);

  Stream<bool> get errorOccur => _currentUserController.stream.transform(
          StreamTransformer<ApiResponse<UserModel>, bool>.fromHandlers(
              handleData: (response, sink) {
        sink.add(response.status == Status.ERROR);
      }));

  /* *******************************************************
    METHODS
   ********************************************************/
  getCurrentUser() async {
    if (_currentUser != null) return;
    var user = await _repository.getLocalUser();
    _currentUser = user?.name;
    if (user != null) {
      _localUserController.sink.add(_currentUser);
      _userNameController.sink.add(_currentUser);
    }
  }

//_currentUserController.sink.add(await _repository.getLocalUser());

  loginPressed() async {
    _currentUserController.sink.add(ApiResponse.loading('loading'));
    var response = await _repository.checkUsers(_credentials);
    if (response != null && response.status == Status.COMPLETED) {
      _passwordController.sink.add('');
      await _repository.saveLocalUser(user: response.data);
      if (response.data.locations.isEmpty) {
        _currentUserController.sink.add(
            ApiResponse.error('Acest user nu are asociat nici o gestiune.'));
        return;
      }
      if (response.data.locations.length == 1)
        await _saveCurrentLocation(response.data.locations.first);

      final navKey = NavKey.navKey;
      navKey.currentState.pushNamed(response.data.locations.length == 1
          ? HomePage.route
          : LocationsPage.route);
    }
    _currentUserController.sink.add(response);
  }

  navigateToHomePage(LocationModel withLocation) async {
    await _saveCurrentLocation(withLocation);
    final navKey = NavKey.navKey;
    navKey.currentState.pushNamed(HomePage.route);
  }

  _saveCurrentLocation(LocationModel location) async =>
      await _repository.saveLocalLocation(location: location);

  @override
  void dispose() {
    _currentUserController?.close();
    _localUserController?.close();
    _userNameController?.close();
    _passwordController?.close();
    _repository.dispose();
  }
}
