
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/home_event.dart';
import 'package:pacointro/blocs/home_state.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/repository/preferences_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => EmptyState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is InitCurrentLocationEvent) {
      var prefs = PreferencesRepository();
      LocationModel location = await prefs.getLocalLocation();
      yield LocationInitiatedState(location);
    }

    if (event is ScanBarcodeEvent) {
      try {
        ScanResult barcode = await BarcodeScanner.scan();
        if (barcode.type == ResultType.Barcode) {
          yield ScanningSuccessfullyState(barcode.rawContent);
        }
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.cameraAccessDenied)
          yield ScanningErrorState(
              'The user did not grant the camera permission!');
        else
          yield ScanningErrorState('Unknown error: $e');
      }
    }

    if(event is CheckLocalOrderEvent) {
      print('check');
      var prefs = PreferencesRepository();
      OrderModel currentOrder = await prefs.getLocalOrder();
      yield CurrentOrderState(currentOrder);
    }
  }
}
