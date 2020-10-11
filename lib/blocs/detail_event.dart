import 'package:flutter/material.dart';

@immutable
abstract class DetailEvent {}

class ChangeStartDateEvent extends DetailEvent {
  final DateTime date;

  ChangeStartDateEvent(this.date);
}

class ChangeEndDateEvent extends DetailEvent {
  final DateTime date;

  ChangeEndDateEvent(this.date);
}
