import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _image;
  String? _profilePicBase64;
  String? _profilePicContentType;

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage(_image!);
      // Reload the profile pic after uploading
      _loadProfilePic();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenBB');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://{Config.ipAddress}:3000/api/babysitters/uploadProfilePic'),
    );

    // Ajouter le jeton dans le corps de la requête
    request.fields['token'] = token ?? '';

    // Ajouter le fichier à la requête
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    // Envoyer la requête
    var response = await request.send();

    // Vérifier la réponse
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  }

  Future<void> _loadProfilePic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenBB');

    if (token != null) {
      final response = await http.get(
        Uri.parse(
            'http://{Config.ipAddress}:3000/api/babysitters/getProfilePic'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        final data = json.decode(response.body);
        setState(() {
          _profilePicBase64 = data['profilePicData'];
          _profilePicContentType = data['profilePicContentType'];
        });
      } else {
        print(response.statusCode);

        print('Failed to load profile picture: ${response.statusCode}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: _image != null
                ? FileImage(_image!)
                : _profilePicBase64 != null
                    ? MemoryImage(base64Decode(_profilePicBase64!))
                        as ImageProvider<Object>?
                    : null,
            child: _image == null && _profilePicBase64 == null
                ? const Icon(Icons.person)
                : null,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: const Color(0xFFF5F6F9),
                  shape: const CircleBorder(),
                ),
                onPressed: _getImageFromCamera,
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
