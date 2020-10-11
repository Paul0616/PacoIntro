import 'package:flutter/material.dart';

@immutable
abstract class ListProductsEvent {}

class MakeBalanceEvent extends ListProductsEvent {}

class GetScannedProductsEvent extends ListProductsEvent {}

class RefreshEvent extends ListProductsEvent {}

class DeleteItemEvent extends ListProductsEvent {
  final int id;

  DeleteItemEvent(this.id);
}