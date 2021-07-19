import 'package:flutter/material.dart';
import 'package:pacointro/models/invoice_model.dart';
import 'package:pacointro/models/order_model.dart';

@immutable
abstract class InvoiceEvent {}

class EmptyInvoiceEvent extends InvoiceEvent {}

class AddNewInvoiceEvent extends InvoiceEvent {
  AddNewInvoiceEvent();
}

class SaveInvoiceEvent extends InvoiceEvent {
  SaveInvoiceEvent();
}

class InvoiceNumberChangeEvent extends InvoiceEvent {
  final String invoiceNumber;
  InvoiceNumberChangeEvent(this.invoiceNumber);
}

class InvoiceDateChangeEvent extends InvoiceEvent {
  final DateTime invoiceDate;
  InvoiceDateChangeEvent(this.invoiceDate);
}

class SelectInvoiceEvent extends InvoiceEvent {
  final InvoiceModel invoice;
  SelectInvoiceEvent(this.invoice);
}

class RemoveInvoiceEvent extends InvoiceEvent {
  final InvoiceModel invoice;
  RemoveInvoiceEvent(this.invoice);
}

class NavigateToSummaryEvent extends InvoiceEvent {
  NavigateToSummaryEvent();
}


