class AppException implements Exception {
  final _message;

  AppException([this._message]);

  @override
  String toString() {
    return '$_message';
  }
}

class SignInFailedException extends AppException {
  SignInFailedException([String? message]) : super(message);
}

class SignUpFailedException extends AppException {
  SignUpFailedException([String? message]) : super(message);
}

class DataSavedException extends AppException {
  DataSavedException([String? message]) : super(message);
}

class NetworkFailedException extends AppException {
  NetworkFailedException([String? message]) : super(message);
}

class NoDataException extends AppException {
  NoDataException([String? message]) : super(message);
}

class MessageSentFailedException extends AppException {
  MessageSentFailedException([String? message]) : super(message);
}
