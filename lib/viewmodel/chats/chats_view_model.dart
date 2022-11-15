import 'dart:convert';

import 'package:chat_application/di/app_initializer.dart';
import 'package:chat_application/model/ChatUser.dart';
import 'package:chat_application/model/Message.dart';
import 'package:chat_application/repository/app_repository.dart';
import 'package:chat_application/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatsViewModel extends ChangeNotifier {
  bool isLoading = false;
  final messageController = TextEditingController();
  final _repository = AppInitializer.getIt<AppRepository>();
  ChatUser? user;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future getUserDataByRef({required String ref}) async {
    setLoading(true);
    _repository.getUserDataByRef(ref: ref).then((value) async {
      user = value;
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      showToast(message: error.toString());
    });
  }

  Future<dynamic> sendMessage() async {
    String msg = messageController.text.trim();
    Message message = Message(message: msg, sentFrom: 0, token: user?.token);
    _repository
        .sendMessage(message: message, receiverId: user?.ref ?? '')
        .then((value) {
      sendPushMessage(user?.token ?? '', message);
      messageController.clear();
      // showToast(message: 'Message sent');
    }).onError((error, stackTrace) {
      showToast(message: error.toString());
    });
  }

  void sendPushMessage(String token, Message message) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAH2GnLQk:APA91bG9wzZnaWohCD3QBrZKQoEtKJG8774zxlZXalQf17rpItuUFl_JfQFTo1OioKz-3Dj63yVYusETvr3ALaqAcYXz8pc5cVwK-P6tR6s-xxlZBbzqYs9kf9sEl5aCdX2WNlHBrN6J',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': message.message,
              'title': 'New message'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  /*Future<void> sendPushMessage(String token) async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }*/

  String constructFCMPayload(String? token) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': '0',
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification was created via FCM!',
      },
    });
  }
}
