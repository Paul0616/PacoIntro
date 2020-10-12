import 'package:flutter/material.dart';

@immutable
abstract class HomeEvent {}

class InitCurrentLocationEvent extends HomeEvent {}

class ScanBarcodeEvent extends HomeEvent {}

class CheckLocalOrderEvent extends HomeEvent {}
