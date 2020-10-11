import 'package:flutter/material.dart';
import 'package:pacointro/models/location_model.dart';

@immutable
abstract class LocationsEvent {}

class NavigateToHomePageEvent extends LocationsEvent {
  final LocationModel location;

  NavigateToHomePageEvent(this.location);
}
