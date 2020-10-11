import 'package:flutter/material.dart';
import 'package:pacointro/models/credentials_model.dart';

@immutable
abstract class LoginState {
  final bool isValid;
  LoginState(this.isValid);
}

class LoginEmptyState extends LoginState {
  LoginEmptyState() : super(false);
}

class TextFieldsInitializedState extends LoginState {
  final String userName;
  TextFieldsInitializedState(this.userName, bool isValid) : super(isValid);
}

class LoginRefreshState extends LoginState {
  final CredentialModel credentials;
  LoginRefreshState(bool isValid, this.credentials) : super(isValid);
}

class NavigateAwayState extends LoginState {
  NavigateAwayState(bool isValid) : super(isValid);
}
