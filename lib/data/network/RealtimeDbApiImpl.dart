import 'package:chat_application/data/app_exceptions.dart';
import 'package:chat_application/data/network/RealtimeDbApi.dart';
import 'package:chat_application/data/user_data.dart';
import 'package:chat_application/model/ChatUser.dart';
import 'package:chat_application/model/Message.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDbApiImpl extends RealtimeDbApi {
  @override
  Future sendMessage({required Message message, required receiverId}) async {
    try {
      ChatUser sender = UserData.user;
      //Store in senders data
      message.sentFrom = 0;
      await FirebaseDatabase.instance
          .ref('users')
          .child(sender.ref ?? '')
          .child(receiverId)
          .push()
          .set(message.toJson());

      //Store in receivers data
      message.sentFrom = 1;
      message.token = sender.token;
      await FirebaseDatabase.instance
          .ref('users')
          .child(receiverId)
          .child(sender.ref ?? '')
          .push()
          .set(message.toJson());

      return true;
    } on Exception catch (e) {
      throw MessageSentFailedException(e.toString());
    }
  }
}
