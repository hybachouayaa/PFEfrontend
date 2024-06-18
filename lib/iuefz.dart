// import 'dart:convert';
// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/services.dart';
// import 'package:googleapis_auth/auth_io.dart';

// class FirebaseAPI {
//   static String? fcmToken;
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   Future<void> initNotification() async {
//     await _firebaseMessaging.requestPermission();
//   }

//   Future<void> getToken() async {
//     fcmToken = await _firebaseMessaging.getToken() ?? "";
//     log("fcm token ==> $fcmToken");
//   }

//   void sendNotification({
//     required String to,
//     required String title,
//     required String body,
//   }) async {
//     String fcmUrl =
//         'https://fcm.googleapis.com/v1/projects/telnet-ac15c/messages:send';
//     const String serviceAccountKeyPath = 'assets/telnet_service_account.json';

//     try {
//       final serviceAccountJson =
//           await rootBundle.loadString(serviceAccountKeyPath);
//       final serviceAccountCredentials =
//           ServiceAccountCredentials.fromJson(serviceAccountJson);

//       final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

//       final authClient =
//           await clientViaServiceAccount(serviceAccountCredentials, scopes);

//       final payload = {
//         'message': {
//           'token': to,
//           'notification': {
//             'title': title,
//             'body': body,
//           },
//         },
//       };

//       try {
//         final response = await authClient.post(
//           Uri.parse(fcmUrl),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode(payload),
//         );

//         if (response.statusCode == 200) {
//           print('Notification sent successfully.');
//         } else {
//           print(
//               'Failed to send notification. Status code: ${response.statusCode}');
//           print('Response body: ${response.body}');
//         }
//       } catch (e) {
//         print('Error sending notification: $e');
//       } finally {
//         authClient.close();
//       }
//     } catch (e) {
//       print('Error loading service account credentials: $e');
//     }
//   }

//   Future<void> deleteFcmToken() async {
//     await _firebaseMessaging.deleteToken();
//   }
// }













// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await FirebaseAPI().initNotification();
//     await FirebaseAPI().getToken(); 
//   runApp(const MyApp());
// }

