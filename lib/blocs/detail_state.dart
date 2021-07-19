import 'package:flutter/material.dart';
import 'package:pacointro/models/location_model.dart';

@immutable
abstract class DetailState {}

class LocationInitiatedState extends DetailState {
  final LocationModel location;
  LocationInitiatedState(this.location);
}

class EmptyState extends DetailState {
  final DateTime date = DateTime.now();
}

// class RefreshStartDateState extends DetailState {
//   final DateTime startDate;
//
//   RefreshStartDateState(this.startDate);
// }
//
// class RefreshEndDateState extends DetailState {
//   final DateTime endDate;
//
//   RefreshEndDateState(this.endDate);
// }

class RefreshDateState extends DetailState {
  final DateTime startDate;
  final DateTime endDate;

  RefreshDateState({this.startDate, this.endDate});
}

