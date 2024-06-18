import 'dart:convert';

import 'package:babysitter/config.dart';
import 'package:babysitter/screens/auth/models/babysitter_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geocoding/geocoding.dart';

class HomeService {
  Future<List<BabysitterModel>> fetchBabySitters() async {
    try {
      var response = await http.get(
        Uri.parse(
            "http://${Config.ipAddress}:3000/api/babysitters/demandes/acceptees"),
        headers: {
          "Content-Type": "application/json",
        },
      );
      print(response.body);
      List result = json.decode(response.body);
      if (response.statusCode == 200) {
        List<BabysitterModel> babysitters = [];
        for (var babysitterData in result) {
          List<RendezVous> rendezVousList = [];
          for (var rendezVousData in babysitterData['rendezVous']) {
            RendezVous rendezVous = RendezVous.fromJson(rendezVousData);
            rendezVousList.add(rendezVous);
          }

          BabysitterModel user = BabysitterModel(
            id: babysitterData['_id'] ?? '',
            nom: babysitterData['nom'] ?? '',
            prenom: babysitterData['prenom'] ?? '',
            email: babysitterData['email'] ?? '',
            password: babysitterData['password'] ?? '',
            phone: babysitterData['phone'] ?? '',
            description: babysitterData['description'] ?? '',
            accepte: babysitterData['accepte'] ?? '',
            fcmToken: babysitterData["fcmToken"] ?? "",
            rendezVous: rendezVousList,
          );
          babysitters.add(user);
        }

        return babysitters;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  updateCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final prefs = await SharedPreferences.getInstance();

        String? token = prefs.getString('tokenBB') ?? 'No token';
        Map<String, dynamic>? user = GetStorage().read('baby-sitter');

        var uri = Uri.parse(
            "http://${Config.ipAddress}:3000/api/babysitters/update/$token");

        List<Placemark> newPlace = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        final Map<String, dynamic> data = {
          "latitude": position.latitude,
          "longitude": position.longitude,
          "description":
              "${newPlace[0].country}, ${newPlace[0].administrativeArea}, ${newPlace[0].locality}  ${newPlace[0].thoroughfare}",
        };
        var request = http.MultipartRequest('PUT', uri);

        // Add text fields to the request
        request.fields['nom'] = user!['nom'];
        request.fields['prenom'] = user['prenom'];
        request.fields['email'] = user["email"];
        request.fields['phone'] = user["phone"];
        request.fields['password'] = user["password"];
        request.fields['description'] = user['description'];
        request.fields["location"] = json.encode(data);

        // Send the request
        var response = await request.send();

        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var responseBody = json.decode(responseData);
          BabysitterModel user = BabysitterModel(
            id: responseBody['_id'],
            nom: responseBody['nom'],
            prenom: responseBody['prenom'],
            email: responseBody['email'],
            phone: responseBody['phone'],
            password: responseBody['password'],
            description: responseBody['description'],
            location: Localisation.fromJson(responseBody["location"]),
            accepte: '',
            rendezVous: [],
            fcmToken: '',
          );
          GetStorage().write('baby-sitter', user.toJson());
          return 'success';
        } else {
          print(
              'Failed to send location data. Status Code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error updating location: $e');
      }
    } else {
      print('Location permission not granted.');
    }
  }
}
