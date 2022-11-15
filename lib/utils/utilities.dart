import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String getUserName() {
  String name = FirebaseAuth.instance.currentUser?.email ?? 'No name';
  int end = 0;
  for (int i = 0; i < name.length; i++) {
    if (name[i] == '@') {
      end = i;
      break;
    }
  }
  return name[0].toUpperCase() + name.substring(1, end);
}

Widget centerText({required text}) {
  return Center(child: Text(text));
}

Future<bool> isConnected() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    showToast(message: 'No internet connection');
    return false;
  }
}

void showToast({required message}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 14.0);
}

Widget horizontalSpacing(double width) {
  return SizedBox(
    width: width,
  );
}

Widget verticalSpacing(double height) {
  return SizedBox(
    height: height,
  );
}
