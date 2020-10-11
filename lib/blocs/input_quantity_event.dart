import 'package:flutter/material.dart';

@immutable
abstract class InputQuantityEvent {}

class QuantityChangeEvent extends InputQuantityEvent {
  final newQuantity;
  QuantityChangeEvent(this.newQuantity);
}
