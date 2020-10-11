import 'package:flutter/material.dart';
import 'package:pacointro/models/balance_item.dart';

@immutable
abstract class ListProductsState {}

class EmptyListState extends ListProductsState {}

class LoadingBalanceState extends ListProductsState {
  final String message;
  LoadingBalanceState(this.message);
}

class BalanceLoadedState extends ListProductsState {
  final List<BalanceItemModel> items;

  BalanceLoadedState(this.items);
}
