import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pacointro/utils/constants.dart';

abstract class ApiCallState extends Equatable {
  const ApiCallState();
  @override
  List<Object> get props => [];
}

class ApiCallEmptyState extends ApiCallState {}

class ApiCallLoadingState extends ApiCallState {
  final String loadingMessage;
  ApiCallLoadingState(this.loadingMessage);
}

class ApiCallLoadedState extends ApiCallState {
  final dynamic response;
  final CallId callId;
  const ApiCallLoadedState({@required this.response, this.callId})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class ApiCallErrorState extends ApiCallState {
  final String message;
  const ApiCallErrorState({this.message});
}
