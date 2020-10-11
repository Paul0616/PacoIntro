import 'package:flutter/material.dart';
import 'package:pacointro/models/invoice_model.dart';
import 'package:pacointro/models/product_model.dart';

@immutable
abstract class OrderSummaryState {}

class EmptyOrderSummaryState extends OrderSummaryState {}

class ProductBelongOrderState extends OrderSummaryState {
  final ProductModel product;

  ProductBelongOrderState(this.product);
}
