import 'package:babysitter/localisation_bbsitter/localisation_baby_sitter.dart';
import 'package:babysitter/screens/auth/signin_screen.dart';
import 'package:babysitter/screens/profile/rendezVousBabySitter.dart';
import 'package:babysitter/screens/profile/update_profiile_bb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  final String type;
  static String routeName = "/profile";

  const ProfileScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? user = GetStorage().read(type);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            user == null
                ? const SizedBox()
                : Text(
                    "${user['nom'] ?? ''}", // Remplacez par le nom et le prénom réel
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            user == null
                ? const SizedBox()
                : Text(
                    "${user['email'] ?? ''}", // Remplacez par l'adresse e-mail réelle
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: CupertinoIcons.profile_circled,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (e) => const UpdateProfiileBb(
                      type: 'baby-sitter',
                    ),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "My localisation",
              icon: CupertinoIcons.profile_circled,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (e) => const LocalisationBBsitter(),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "Rendez Vous",
              icon: CupertinoIcons.bell,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (e) => const RendezVousBabySitter(
                      type: 'babysitter',
                    ),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: CupertinoIcons.bell,
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: CupertinoIcons.settings,
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: CupertinoIcons.info,
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: CupertinoIcons.power,
              press: () async {
                // Supprimer le token des préférences partagées
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove(
                    'tokenBB'); // Supprimer le token utilisé pour la baby-sitter

                // Naviguer vers l'écran de connexion
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(type: 'baby-sitter'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
