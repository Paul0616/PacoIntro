import 'package:flutter/material.dart';
import 'package:pacointro/models/invoice_model.dart';
import 'package:pacointro/models/product_model.dart';

@immutable
abstract class InputQuantityState {}

class EmptyOrderSummaryState extends InputQuantityState {}

class ValidationQuantityState extends InputQuantityState {
  final bool isValid;

  ValidationQuantityState(this.isValid);
}
