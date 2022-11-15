import 'package:chat_application/model/Message.dart';

abstract class RealtimeDbApi {
  Future<dynamic> sendMessage({required Message message, required receiverId});
}
