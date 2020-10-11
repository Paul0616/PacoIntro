import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/order_input_event.dart';
import 'package:pacointro/blocs/order_input_state.dart';
import 'package:pacointro/models/invoice_model.dart';

class OrderInputBloc extends Bloc<OrderInputEvent, OrderInputState> {
  String _invoiceNumber;
  DateTime _invoiceDate;
  @override
  OrderInputState get initialState => EmptyOrderState();

  @override
  Stream<OrderInputState> mapEventToState(OrderInputEvent event) async* {
    if (event is OrderNumberChangeEvent) {
      print(event.orderNumber);
      yield ValidationSendRequestState(true, event.orderNumber);
    }

    if (event is InvoiceNumberChangeEvent) {
      _invoiceNumber = event.invoiceNumber;
      print(_invoiceNumber);
      yield ValidationInvoiceState(InvoiceModel(
          invoiceNumber: _invoiceNumber, invoiceDate: _invoiceDate));
    }

    if (event is InvoiceDateChangeEvent) {
      _invoiceDate = event.invoiceDate;
      yield ValidationInvoiceState(InvoiceModel(
          invoiceNumber: _invoiceNumber, invoiceDate: _invoiceDate));
    }
  }
}
