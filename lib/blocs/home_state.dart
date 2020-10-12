import 'package:flutter/material.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/order_model.dart';

@immutable
abstract class HomeState {}

class LocationInitiatedState extends HomeState {
  final LocationModel location;
  LocationInitiatedState(this.location);
}

class EmptyState extends HomeState {}

class ScanningErrorState extends HomeState {
  final String message;

  ScanningErrorState(this.message);
}

class ScanningSuccessfullyState extends HomeState {
  final String barcode;

  ScanningSuccessfullyState(this.barcode);
}

class CurrentOrderState extends HomeState {
  final OrderModel currentOrder;

  CurrentOrderState(this.currentOrder);

}