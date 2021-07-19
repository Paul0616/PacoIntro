import 'package:flutter/material.dart';
import 'package:pacointro/models/invoice_model.dart';
import 'package:pacointro/models/order_model.dart';

@immutable
abstract class InvoiceState {}

class GetOrderState extends InvoiceState {
  final OrderModel order;
  GetOrderState(this.order);
}

// class ShowInvoiceTextFieldsState extends InvoiceState {
//   ShowInvoiceTextFieldsState();
// }

// class ValidationSendRequestState extends InvoiceState {
//   final bool isValid;
//   final String orderNumber;
//
//   ValidationSendRequestState(this.isValid, this.orderNumber);
// }
//
class ValidationInvoiceState extends InvoiceState {
  final InvoiceModel invoice;

  ValidationInvoiceState(this.invoice);
}


// class NavigateToSummaryState extends InvoiceState {}
