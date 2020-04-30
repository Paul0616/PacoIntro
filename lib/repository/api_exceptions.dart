class ApiException implements Exception {
  final _message;

  ApiException([this._message]);

  String toString() {
    return "$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String message]);
}

class BadRequestException extends ApiException {
  BadRequestException([message]);
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([String message]);
}

class InvalidInputException extends ApiException {
  InvalidInputException([String message]);
}

class NotFoundException extends ApiException {
  NotFoundException([String message]);
}
