import 'package:flutter/material.dart';
import 'package:pacointro/models/order_model.dart';

@immutable
abstract class OrderInputEvent {}

class OrderNumberChangeEvent extends OrderInputEvent {
  final String orderNumber;

  OrderNumberChangeEvent(this.orderNumber);
}

class InvoiceNumberChangeEvent extends OrderInputEvent {
  final String invoiceNumber;

  InvoiceNumberChangeEvent(this.invoiceNumber);
}

class InvoiceDateChangeEvent extends OrderInputEvent {
  final DateTime invoiceDate;

  InvoiceDateChangeEvent(this.invoiceDate);
}

class SaveToPrefsCurrentOrderEvent extends OrderInputEvent {
  final OrderModel order;
  SaveToPrefsCurrentOrderEvent(this.order);
}


class NavigateToSummaryEvent extends OrderInputEvent {
  NavigateToSummaryEvent();
}

class EmptyEvent extends OrderInputEvent {}
