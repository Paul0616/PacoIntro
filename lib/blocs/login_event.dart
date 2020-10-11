import 'package:flutter/material.dart';

@immutable
abstract class LoginEvent {}

class InitTextFieldsEvent extends LoginEvent {}

class UserNameChangeEvent extends LoginEvent {
  final newUsername;
  UserNameChangeEvent(this.newUsername);
}

class PasswordChangeEvent extends LoginEvent {
  final newPassword;
  PasswordChangeEvent(this.newPassword);
}

class NavigateToLocations extends LoginEvent {}
