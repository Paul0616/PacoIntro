import 'package:flutter/material.dart';

@immutable
abstract class OrderInputState {}

class EmptyOrderState extends OrderInputState {}

class ValidationSendRequestState extends OrderInputState {
  final bool isValid;
  final String orderNumber;

  ValidationSendRequestState(this.isValid, this.orderNumber);
}

// class ValidationInvoiceState extends OrderInputState {
//   final InvoiceModel invoice;
//
//   ValidationInvoiceState(this.invoice);
// }


class NavigateToSummaryState extends OrderInputState {}
