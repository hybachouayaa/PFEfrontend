import 'dart:convert';
import 'dart:io';
import 'package:babysitter/config.dart';
import 'package:babysitter/screens/auth/models/babysitter_model.dart';
import 'package:babysitter/screens/auth/models/parent_model.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UptadeProfile {
  Map<String, dynamic>? user = GetStorage().read('parent');

  Future<String> updateAccount(
    String nom,
    String prenom,
    String email,
    String phone,
    String password,
    String nbEnfants,
  ) async {
    try {
      final requestBodyJson = json.encode({
        "nom": nom,
        "prenom": prenom,
        "email": email,
        "password": password,
        "phone": phone,
        "nombreDesEnfants": nbEnfants,
      });
      var response = await http.put(
        Uri.parse("http://${Config.ipAddress}:3000/api/babysitters"),
        body: requestBodyJson,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${user!['token']}',
        },
      );
      var updateJson = json.decode(response.body.toString());
      if (response.statusCode == 200) {
        ParentModel user = ParentModel(
          id: updateJson['_id'],
          nom: updateJson['nom'],
          prenom: updateJson['prenom'],
          email: updateJson['email'],
          phone: updateJson['phone'],
          password: updateJson['password'],
          nbEnfants: updateJson['nombreDesEnfants'],
        );
        GetStorage().write('parent', user.toJson());
        return 'succes';
      } else {
        return 'error';
      }
    } catch (e) {
      print(e.toString());
    }

    return '';
  }

  Future<String> updateAccountt(
    String nom,
    String prenom,
    String email,
    String phone,
    String password,
    String description,
    File? profilePic, // Pass the file here if needed
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('tokenBB') ?? 'No token';

      var uri = Uri.parse(
          "http://${Config.ipAddress}:3000/api/babysitters/update/$token");
      var request = http.MultipartRequest('PUT', uri);

      // Add text fields to the request
      request.fields['nom'] = nom;
      request.fields['prenom'] = prenom;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['password'] = password;
      request.fields['description'] = description;

      // Add file to the request if present
      if (profilePic != null) {
        var stream = http.ByteStream(profilePic.openRead());
        var length = await profilePic.length();
        var multipartFile = http.MultipartFile('file', stream, length,
            filename: profilePic.path.split('/').last);
        request.files.add(multipartFile);
      }

      // Add headers
      // request.headers['Authorization'] = 'Bearer ${user!['token']}';

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var updateJson = json.decode(responseData);
        BabysitterModel user = BabysitterModel(
          id: updateJson['_id'],
          nom: updateJson['nom'],
          prenom: updateJson['prenom'],
          email: updateJson['email'],
          phone: updateJson['phone'],
          password: updateJson['password'],
          description: updateJson['description'],
          accepte: '',
          rendezVous: [],
          fcmToken: '',
        );
        GetStorage().write('baby-sitter', user.toJson());
        return 'success';
      } else {
        return 'error';
      }
    } catch (e) {
      print(e.toString());
      return 'bien';
    }
  }
}
