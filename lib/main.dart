import 'dart:convert';

import 'package:babysitter/calendarForBabysitter.dart';
import 'package:babysitter/screens/onboarding_screen/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:babysitter/theme/theme.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that the binding is initialized

  await Firebase.initializeApp();

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpenedApp: $message");
    Navigator.pushNamed(navigatorKey.currentState!.context, 'routeName',
        arguments: {"message", json.encode(message.data)});
  });

  FirebaseMessaging.instance.getToken().then((value) {
    print("getToken : $value");
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      Navigator.pushNamed(navigatorKey.currentState!.context, 'routeName',
          arguments: {"message", json.encode(message.data)});
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("oizejfpezjfpoezjfpezj: $message");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BabySitterApp',
        theme: lightMode,
        home: const OnboardingScreen(), // Specify the home property
        navigatorKey: navigatorKey,
        routes: {
          // Remove the redundant '/' route
          'calendrier': (context) => const CalendrierRendezVousPage(
                babysitterName: "",
              ),
        });
  }
}
