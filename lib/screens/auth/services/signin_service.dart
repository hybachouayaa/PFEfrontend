import 'dart:convert';
import 'package:babysitter/config.dart';
import 'package:babysitter/screens/auth/models/babysitter_model.dart';
import 'package:babysitter/screens/auth/models/parent_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SigninService {
  Future<String> signin(
    String type,
    String email,
    String password,
  ) async {
    try {
      if (type == 'baby-sitter') {
        // Récupérer le FCM token
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        var response = await http.post(
          Uri.parse("http://${Config.ipAddress}:3000/api/babysitters/login"),
          body: json.encode({
            "email": email,
            "password": password,
            "fcmToken":
                fcmToken, // Inclure le FCM token dans le corps de la requête
          }),
          headers: {
            "Content-Type": "application/json",
          },
        );
        print(response.body);
        var signupJson = json.decode(response.body.toString());
        if ((response.statusCode == 201) || (response.statusCode == 200)) {
          String token = signupJson['mytoken'];
          print("houniiiiiii : $token");
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('tokenBB', token);
          BabysitterModel user = BabysitterModel.fromJson(signupJson);
          GetStorage().write('babysitter', user.toJson());
          return 'success';
        } else {
          return signupJson['message'];
        }
      } else {
        var response = await http.post(
          Uri.parse("http://${Config.ipAddress}:3000/api/parents/login"),
          body: json.encode({"email": email, "password": password}),
          headers: {
            "Content-Type": "application/json",
          },
        );
        print(response.body);
        var signupJson = json.decode(response.body.toString());
        if (response.statusCode == 200 || response.statusCode == 201) {
          String token = signupJson['mytokenparent']
              .toString(); // Assuming the token is returned in the response
          // Store token using shared preferences
          print("houniiiiiii : $token");
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('tokenPR', token);
          ParentModel user = ParentModel.fromJson(signupJson);
          GetStorage().write('parent', user.toJson());
          return 'success';
        } else {
          return signupJson['message'];
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return '';
  }
}
