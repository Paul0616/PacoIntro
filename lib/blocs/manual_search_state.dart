import 'package:flutter/material.dart';

@immutable
abstract class ManualSearchState {}

class SearchWidgetEnabledState extends ManualSearchState {
  final bool isEnabled;
  SearchWidgetEnabledState(this.isEnabled);
}

class EmptyState extends ManualSearchState {}
