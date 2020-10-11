import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/detail_event.dart';
import 'package:pacointro/blocs/detail_state.dart';

import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/repository/preferences_repository.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  @override
  DetailState get initialState => EmptyState();

  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    if (event is ChangeStartDateEvent) {
      var prefs = PreferencesRepository();
      LocationModel location = await prefs.getLocalLocation();
      yield LocationInitiatedState(location);
    }

    if (event is ChangeStartDateEvent) {
      _startDate = event.date;
      yield RefreshStartDateState(_startDate);
    }
    if (event is ChangeEndDateEvent) {
      _endDate = event.date;
      yield RefreshEndDateState(_endDate);
    }
  }
}
