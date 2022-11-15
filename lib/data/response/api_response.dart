import 'package:chat_application/data/response/status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse(
      {required this.status, required this.data, required this.message});

  ApiResponse.loading() : status = Status.LOADING;
  ApiResponse.done() : status = Status.DONE;
  ApiResponse.error() : status = Status.ERROR;

  @override
  String toString() {
    return 'Status : $status\nMessage : $message\nData: $data';
  }
}
