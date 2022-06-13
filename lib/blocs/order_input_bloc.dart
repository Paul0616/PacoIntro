import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/order_input_event.dart';
import 'package:pacointro/blocs/order_input_state.dart';

import 'package:pacointro/repository/preferences_repository.dart';

class OrderInputBloc extends Bloc<OrderInputEvent, OrderInputState> {
  // String _invoiceNumber;
  // DateTime _invoiceDate;
  @override
  OrderInputState get initialState => EmptyOrderState();

  @override
  Stream<OrderInputState> mapEventToState(OrderInputEvent event) async* {
    if (event is OrderNumberChangeEvent) {
      print(event.orderNumber);
      yield ValidationSendRequestState(true, event.orderNumber);
    }

    // if (event is InvoiceNumberChangeEvent) {
    //   _invoiceNumber = event.invoiceNumber;
    //   print(_invoiceNumber);
    //   yield ValidationInvoiceState(InvoiceModel(
    //       invoiceNumber: _invoiceNumber, invoiceDate: _invoiceDate));
    // }
    //
    // if (event is InvoiceDateChangeEvent) {
    //   _invoiceDate = event.invoiceDate;
    //   yield ValidationInvoiceState(InvoiceModel(
    //       invoiceNumber: _invoiceNumber, invoiceDate: _invoiceDate));
    // }

    if(event is SaveToPrefsCurrentOrderEvent) {
      var oldOrder = await PreferencesRepository().getLocalOrder();
      if(oldOrder?.invoices?.isNotEmpty ?? false){
        event.order.invoices = oldOrder.invoices;
      }
     
      await PreferencesRepository().saveLocalOrder(order: event.order);
      yield NavigateToSummaryState();
    }

    if(event is NavigateToSummaryEvent) {
      yield NavigateToSummaryState();
    }

    if(event is EmptyEvent){
      yield EmptyOrderState();
    }
  }
}
