import 'package:flutter/material.dart';
import 'package:pacointro/utils/constants.dart';

@immutable
abstract class ManualSearchEvent {}

class ValidateSearchTextEvent extends ManualSearchEvent {
  final String searchText;
  final SearchType searchType;

  ValidateSearchTextEvent(this.searchText, this.searchType);
}
