import 'package:flutter/material.dart';
import 'package:pacointro/models/product_model.dart';

@immutable
abstract class InputQuantityEvent {}

class QuantityChangeEvent extends InputQuantityEvent {
  final newQuantity;
  QuantityChangeEvent(this.newQuantity);
}

class SaveProductReceptionEvent extends InputQuantityEvent {
  final ProductModel product;
  SaveProductReceptionEvent(this.product);
}


