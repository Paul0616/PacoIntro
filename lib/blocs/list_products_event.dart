import 'package:flutter/material.dart';

@immutable
abstract class ListProductsEvent {}

class MakeBalanceEvent extends ListProductsEvent {}

class GetScannedProductsEvent extends ListProductsEvent {}
