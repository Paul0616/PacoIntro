import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pacointro/blocs/manual_search_event.dart';
import 'package:pacointro/blocs/manual_search_state.dart';

import 'package:pacointro/utils/constants.dart';

class ManualSearchBloc extends Bloc<ManualSearchEvent, ManualSearchState> {
  String _searchText;

  String get searchText => _searchText;

  @override
  ManualSearchState get initialState => EmptyState();

  @override
  Stream<ManualSearchState> mapEventToState(ManualSearchEvent event) async* {
    if (event is ValidateSearchTextEvent) {
      _searchText = event.searchText;
      yield SearchWidgetEnabledState(event.searchText.length >
          (event.searchType == SearchType.BY_CODE ? 0 : 2));
    }
  }
}
