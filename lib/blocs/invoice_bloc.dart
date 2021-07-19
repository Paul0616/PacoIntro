import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/invoice_model.dart';
import 'package:pacointro/repository/preferences_repository.dart';

import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  String _invoiceNumber;
  DateTime _invoiceDate;

  @override
  InvoiceState get initialState => GetOrderState(null);

  @override
  Stream<InvoiceState> mapEventToState(InvoiceEvent event) async* {
    if (event is InvoiceNumberChangeEvent) {
      _invoiceNumber = event.invoiceNumber;
      yield ValidationInvoiceState(InvoiceModel(
          id: null,
          invoiceNumber: _invoiceNumber,
          invoiceDate: _invoiceDate,
          isCurrent: false));
    }

    if (event is InvoiceDateChangeEvent) {
      _invoiceDate = event.invoiceDate;
      yield ValidationInvoiceState(InvoiceModel(
          id: null,
          invoiceNumber: _invoiceNumber,
          invoiceDate: _invoiceDate,
          isCurrent: false));
    }

    if (event is SaveInvoiceEvent) {
      var order = await PreferencesRepository().getLocalOrder();
      order.invoices.forEach((element) {
        element.isCurrent = false;
      });
      order.invoices.insert(0, InvoiceModel(
          id: order.nextAvailableInvoiceId,
          invoiceNumber: _invoiceNumber,
          invoiceDate: _invoiceDate,
          isCurrent: true));
      _invoiceNumber = null;
      _invoiceDate = null;
      await PreferencesRepository().saveLocalOrder(order: order);
      yield GetOrderState(order);
    }

    if(event is SelectInvoiceEvent){
      var order = await PreferencesRepository().getLocalOrder();
      order.invoices.forEach((element) {
        element.isCurrent = element.id == event.invoice.id;
      });
      await PreferencesRepository().saveLocalOrder(order: order);
      yield GetOrderState(order);
    }

    if(event is RemoveInvoiceEvent){
      var order = await PreferencesRepository().getLocalOrder();
      var scannedProducts = await DBProvider.db.getProductsByOrderType(productType: ProductType.RECEPTION);
      if(scannedProducts.any((element) => element.invoiceId == event.invoice.id)){
        var affectedProducts = scannedProducts.where((element) => element.invoiceId == event.invoice.id).toList();
        for(var product in affectedProducts) {
          await DBProvider.db.deleteProductById(id: product.id);
        }
      }
      order.invoices.retainWhere((element) => element.id != event.invoice.id);
      if(order.invoices.isNotEmpty && !order.invoices.any((element) => element.isCurrent)){
        order.invoices[0].isCurrent = true;
      }
      await PreferencesRepository().saveLocalOrder(order: order);
      yield GetOrderState(order);
    }

    if (event is AddNewInvoiceEvent) {
      yield ValidationInvoiceState(null);
    }

    if (event is EmptyInvoiceEvent) {
      var order = await PreferencesRepository().getLocalOrder();
      yield GetOrderState(order);
    }
  }
}
