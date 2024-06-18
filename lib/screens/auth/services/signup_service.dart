import 'dart:convert';
import 'dart:io';
import 'package:babysitter/config.dart';
import 'package:http/http.dart' as http;

class SignUpService {
  Future<String> signUpBabySitter(
    String nom,
    String prenom,
    String email,
    String password,
    String phone,
    String description,
    File? file,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://${Config.ipAddress}:3000/api/babysitters/signup'),
      );

      // Add fields to the request
      request.fields['nom'] = nom;
      request.fields['prenom'] = prenom;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['phone'] = phone;
      request.fields['description'] = description;

      // Add file if present
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
        ));
      }

      // Send the request
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      var signupJson = json.decode(responseBody.body.toString());

      if (response.statusCode == 201) {
        return 'success';
      } else {
        print("Erreur: ${responseBody.body}");
        return signupJson['message'];
      }
    } catch (e) {
      print("Erreur: $e");
      return 'An error occurred while creating the babysitter.';
    }
  }

  Future<http.Response> sendNotification(String nom, String prenom) async {
    var uri = Uri.parse('http://${Config.ipAddress}:3000/api/admin/addNotif');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nom': nom, 'prenom': prenom}),
    );
    return response;
  }

  Future<String> signUpParent(
    String nom,
    String prenom,
    String email,
    String password,
    String phone,
    String nbEnfants,
  ) async {
    try {
      final requestBodyJson = json.encode({
        "nom": nom,
        "prenom": prenom,
        "email": email,
        "password": password,
        "phone": phone,
        "nombreDesEnfants":
            nbEnfants.toString(), // Convertir nbEnfants en chaîne de caractères
      });
      print(requestBodyJson);
      var response = await http.post(
        Uri.parse('http://${Config.ipAddress}:3000/api/parents/signup'),
        body: requestBodyJson,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print(response.body);
      var signupJson = json.decode(response.body.toString());
      if (response.statusCode == 201) {
        return 'success';
      } else {
        return signupJson['message'];
      }
    } catch (e) {
      print(e.toString());
    }

    return '';
  }
}
