import 'package:chat_application/di/app_initializer.dart';
import 'package:chat_application/notification/push_notification/push_notification_manager.dart';
import 'package:chat_application/routing/router.dart';
import 'package:chat_application/routing/routes.dart';
import 'package:chat_application/viewmodel/auth/auth_view_model.dart';
import 'package:chat_application/viewmodel/chats/chats_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/color_constants.dart';
import 'notification/local_notification/local_notification_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotificationManger.instance.registerLocalNotification();
  await PushNotificationManager.instance.registerPushNotification();
  AppInitializer.initGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ChatsViewModel()),
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: ColorConstants.white),
        onGenerateRoute: PageRouter.generateRoute,
        initialRoute: Routes.splashRoute,
      ),
    );
  }
}
