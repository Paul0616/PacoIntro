import 'package:flutter/material.dart';

import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/progress_model.dart';

@immutable
abstract class OrderSummaryState {}

class EmptyOrderSummaryState extends OrderSummaryState {}

class ProductBelongOrderState extends OrderSummaryState {
  final ProductModel product;

  ProductBelongOrderState(this.product);
}

class UpdateProgressState extends OrderSummaryState {
  final ProgressModel progressModel;

  UpdateProgressState(this.progressModel);
}

class NavigateToHomeState extends OrderSummaryState {}
