import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/input_quantity_event.dart';
import 'package:pacointro/blocs/input_quantity_state.dart';

import 'package:pacointro/database/database.dart';


class InputQuantityBloc extends Bloc<InputQuantityEvent, InputQuantityState> {
  @override
  InputQuantityState get initialState => EmptyOrderSummaryState();

  @override
  Stream<InputQuantityState> mapEventToState(InputQuantityEvent event) async* {
    if (event is QuantityChangeEvent) {
      yield ValidationQuantityState(double.tryParse(event.newQuantity));
    }

    if (event is SaveProductReceptionEvent) {
      await DBProvider.db.insertProduct(event.product, ProductType.RECEPTION);
      yield QuantityInputDoneState();
    }
  }
}
