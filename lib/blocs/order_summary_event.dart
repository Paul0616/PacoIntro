import 'package:flutter/material.dart';

@immutable
abstract class OrderSummaryEvent {}

class FindProductInOrderEvent extends OrderSummaryEvent {
  final int barCode;

  FindProductInOrderEvent(this.barCode);
}

class ProgressRefreshEvent extends OrderSummaryEvent {}

class DeleteOrderAndNavigateEvent extends OrderSummaryEvent {}