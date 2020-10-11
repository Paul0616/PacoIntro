import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/locations_event.dart';

import 'package:pacointro/pages/home_page.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'package:pacointro/utils/nav_key.dart';

class LocationsBloc extends Bloc<LocationsEvent, dynamic> {
  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(LocationsEvent event) async* {
    if (event is NavigateToHomePageEvent) {
      var prefs = PreferencesRepository();
      await prefs.saveLocalLocation(location: event.location);
      NavKey.navKey.currentState.pushNamed(HomePage.route);
    }

    // if (event is UserNameChangeEvent) {
    //   _username = event.newUsername;
    //   yield LoginRefreshState(_isValid(), credentials);
    // }
    //
    // if (event is PasswordChangeEvent) {
    //   _password = event.newPassword;
    //   yield LoginRefreshState(_isValid(), credentials);
    // }
    //
    // if (event is NavigateToLocations) {
    //   yield NavigateAwayState(true);
    // }
  }
}
