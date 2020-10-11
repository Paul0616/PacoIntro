import 'package:flutter/material.dart';

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
