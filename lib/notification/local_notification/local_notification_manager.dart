import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationManger {
  static LocalNotificationManger? _instance;

  late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  static LocalNotificationManger get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = LocalNotificationManger();
      return _instance!;
    }
  }

  Future<void> registerLocalNotification() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const android = AndroidInitializationSettings('launch_background');
    const ios = IOSInitializationSettings();

    final initSetting = InitializationSettings(android: android, iOS: ios);
    await _flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: _onSelectNotification);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    print('Notification channel created');
  }

  void showLocalNotification({required RemoteMessage message}) {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(_channel.id, _channel.name),
          ));
    }
  }

  Future _onSelectNotification(String? payload) async {
    print('Tapped on local notification');
  }
}
