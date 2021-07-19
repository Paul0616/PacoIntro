import 'package:flutter/material.dart';

@immutable
abstract class DetailEvent {}

// class ChangeStartDateEvent extends DetailEvent {
//   final DateTime date;
//
//   ChangeStartDateEvent(this.date);
// }
//
// class ChangeEndDateEvent extends DetailEvent {
//   final DateTime date;
//
//   ChangeEndDateEvent(this.date);
// }

class ChangeDateEvent extends DetailEvent {
  final DateTime startDate;
  final DateTime endDate;
  ChangeDateEvent({this.startDate, this.endDate});
}
