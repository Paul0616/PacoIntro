import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/models/credentials_model.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String _username;
  String _password;

  @override
  LoginState get initialState => LoginEmptyState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is InitTextFieldsEvent) {
      var prefs = PreferencesRepository();
      UserModel userModel = await prefs.getLocalUser();
      _username = userModel == null ? '' : userModel.name;
      yield TextFieldsInitializedState(_username, _isValid());
    }

    if (event is UserNameChangeEvent) {
      _username = event.newUsername;
      yield LoginRefreshState(_isValid(), credentials);
    }

    if (event is PasswordChangeEvent) {
      _password = event.newPassword;
      yield LoginRefreshState(_isValid(), credentials);
    }

    if (event is NavigateToLocations) {
      yield NavigateAwayState(true);
    }
  }

  CredentialModel get credentials =>
      CredentialModel(userName: _username, password: _password);

  bool _isValid() {
    return _username != null &&
        _username.length > 2 &&
        _password != null &&
        _password.length > 1;
  }
}
