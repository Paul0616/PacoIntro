import 'package:flutter/material.dart';


@immutable
abstract class InputQuantityState {}

class EmptyOrderSummaryState extends InputQuantityState {}

class ValidationQuantityState extends InputQuantityState {
  final double quantity;

  ValidationQuantityState(this.quantity);
}

class QuantityInputDoneState extends InputQuantityState{}
