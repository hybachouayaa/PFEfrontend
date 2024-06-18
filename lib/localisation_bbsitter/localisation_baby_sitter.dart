import 'package:babysitter/screens/auth/models/babysitter_model.dart';
import 'package:babysitter/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocalisationBBsitter extends StatefulWidget {
  const LocalisationBBsitter({super.key});

  @override
  _LocalisationBBsitterState createState() => _LocalisationBBsitterState();
}

class _LocalisationBBsitterState extends State<LocalisationBBsitter> {
  Future<Object> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return Geolocator.getPositionStream().listen((Position? position) {
      print("============");
      print(position!.latitude);
      print(position.longitude);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _determinePosition();
    user = GetStorage().read('baby-sitter');
  }

  Set<Marker> myMarker = {};

  BabysitterModel? user;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(children: [
        const Text("location bbsitter"),
        GoogleMap(
          onTap: (tapped) {},
          markers: Set<Marker>.of(myMarker),
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: LatLng(user!.location!.latitude, user!.location!.longitude),
            zoom: 17,
          ),
          compassEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            setState(() {
              // mapController = controller;
            });
          },
        ),
      ]),
    );
  }
}
