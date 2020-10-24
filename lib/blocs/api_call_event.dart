import 'package:equatable/equatable.dart';
import 'package:pacointro/models/credentials_model.dart';
import 'package:pacointro/utils/constants.dart';

abstract class ApiCallEvent extends Equatable {
  const ApiCallEvent();
}

class EmptyEvent extends ApiCallEvent {
  @override
  List<Object> get props => [];
  EmptyEvent();
}

class LoadingEvent extends ApiCallEvent {
  final String loadingMessage;
  @override
  List<Object> get props => [];
  LoadingEvent(this.loadingMessage);
}

class ApiCallErrorEvent extends ApiCallEvent {
  final String message;
  @override
  List<Object> get props => [];
  ApiCallErrorEvent(this.message);
}

class GetTokenEvent extends ApiCallEvent {
  final CredentialModel credentials;
  @override
  List<Object> get props => [];

  GetTokenEvent(this.credentials);
}

class CheckUserEvent extends ApiCallEvent {
  @override
  List<Object> get props => [];
}

class GetProductsEvent extends ApiCallEvent {
  final SearchType searchType;
  final String code;
  final int page;

  GetProductsEvent(this.searchType, this.code, this.page);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetProductDetailsEvent extends ApiCallEvent {
  final int code;

  GetProductDetailsEvent(this.code);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetSalesInPeriodEvent extends ApiCallEvent {
  final int code;
  final DateTime startDate;
  final DateTime endDate;

  GetSalesInPeriodEvent({this.code, this.startDate, this.endDate});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PutProductWithIssueEvent extends ApiCallEvent {
  final int code;
  final int status;

  PutProductWithIssueEvent(this.code, this.status);
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PostReceptionEvent extends ApiCallEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LastInputEvent extends ApiCallEvent {
  final int code;

  LastInputEvent(this.code);
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OrderByNumberEvent extends ApiCallEvent {
  final String orderNumber;

  OrderByNumberEvent(this.orderNumber);
  @override
  // TODO: implement props
  List<Object> get props => [];
}
