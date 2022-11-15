import 'package:chat_application/notification/local_notification/local_notification_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationManager {
  static PushNotificationManager? _instance;

  static PushNotificationManager get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = PushNotificationManager();
      return _instance!;
    }
  }

  Future<void> registerPushNotification() async {
    await _requestNotification();

    await _handleInitialMessageState();

    _handleForegroundState();

    _handleBackgroundState();

    _handleOnMessageOpenedState();
  }

  //Request notification
  Future<void> _requestNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    String? token = await messaging.getToken();
    print('Push Token: $token');
  }

  //Handle initial message state
  Future<void> _handleInitialMessageState() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    print("Got a initial message");
    print('Message data: ${initialMessage?.data}');

    if (initialMessage?.notification != null) {
      //handle event on receiving initial message
      print(
          'Message also contained a notification: ${initialMessage?.notification}');
    }
  }

  //To handle messages while your application is in the background
  void _handleBackgroundState() {
    FirebaseMessaging.onBackgroundMessage((message) async {
      print("Got a message while in the background!");
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        LocalNotificationManger.instance
            .showLocalNotification(message: message);
      }
    });
  }

  //To handle messages while your application is in the foreground
  void _handleForegroundState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        LocalNotificationManger.instance
            .showLocalNotification(message: message);
      }
    });
  }

  //To handle event on when user taps on message
  void _handleOnMessageOpenedState() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Got and tapped on message!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
