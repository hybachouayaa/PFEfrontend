import 'dart:convert';
import 'dart:io';
import 'package:babysitter/config.dart';
import 'package:babysitter/screens/profile/services/update_profile_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:babysitter/screens/auth/signin_screen.dart';
import 'package:babysitter/widgets/custom_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfiileBb extends StatefulWidget {
  final String type;

  const UpdateProfiileBb({super.key, required this.type});
  @override
  State<UpdateProfiileBb> createState() => _UpdateProfiileBbState();
}

class _UpdateProfiileBbState extends State<UpdateProfiileBb> {
  final _formFormKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  String? cvPath;
  TextEditingController nomontroller = TextEditingController();
  TextEditingController prenomontroller = TextEditingController();
  TextEditingController emailontroller = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();
  File? _selectedFile;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchBabysitterData();
  }

  Future<void> fetchBabysitterData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('tokenBB') ??
          'No token'; // Change this to the actual ID
      var response = await http.get(
        Uri.parse('http://${Config.ipAddress}:3000/api/babysitters/$token'),
        headers: {
          'Content-Type': 'application/json',
          // Add any headers you need, like authentication headers
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          print("$data");
          userData = data;

          nomontroller.text = data['nom'] ?? '';
          prenomontroller.text = data['prenom'] ?? '';
          emailontroller.text = data['email'] ?? '';
          phoneController.text = data['phone'] ?? '';
          passwordController.text = data['password'] ?? '';
          descriptionController.text = data['description'] ?? '';
        });
      } else {
        throw Exception('Failed to load babysitter data');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
      // Handle error here
    }
  }

  @override
  void dispose() {
    nomontroller.dispose();
    prenomontroller.dispose();
    emailontroller.dispose();
    phoneController.dispose();
    passwordController.dispose();
    descriptionController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileNameController.text = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                  key: _formFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      const Text(
                        'Update Account',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFD2A0D9),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      // full name
                      TextFormField(
                        controller: nomontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Nom'),
                          hintText: 'Enter Nom',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // full name
                      TextFormField(
                        controller: prenomontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter prenom';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Prenom'),
                          hintText: 'Enter Prenom',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // email
                      TextFormField(
                        controller: emailontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      //phone number
                      TextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Phone number'),
                          hintText: 'Enter your phone number',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // password
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          // Allow empty password if user doesn't want to change it
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText:
                              'Enter Password (leave empty to keep current)',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),

                      TextFormField(
                        controller: descriptionController,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Description'),
                          hintText: 'Enter description',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _fileNameController,
                        decoration:
                            const InputDecoration(labelText: 'File Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a file name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: const Text('Select File'),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: const Color(0xFFD2A0D9),
                          ),
                          const Text(
                            'I agree to the processing of ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          const Text(
                            'Personal data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD2A0D9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // Form button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formFormKey.currentState!.validate() &&
                                agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Data'),
                                ),
                              );

                              print('Nom: ${nomontroller.text}');
                              print('Prenom: ${prenomontroller.text}');
                              print('Email: ${emailontroller.text}');
                              print('Phone: ${phoneController.text}');
                              print('Password: ${passwordController.text}');
                              print(
                                  'Description: ${descriptionController.text}');

                              var result = await UptadeProfile().updateAccountt(
                                nomontroller.text,
                                prenomontroller.text,
                                emailontroller.text,
                                passwordController.text,
                                phoneController.text,
                                descriptionController.text,
                                _selectedFile,
                              );

                              if (result == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Success'),
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (e) =>
                                        SignInScreen(type: widget.type),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $result'),
                                  ),
                                );
                              }
                            } else if (!agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please agree to the processing of personal data')),
                              );
                            }
                          },
                          child: const Text('Update Account'),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      // sign up social media logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/logos/facebook.png',
                            width: 24,
                            height: 24,
                          ),
                          Image.asset(
                            'assets/logos/google.png',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => SignInScreen(
                                    type: widget.type,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD2A0D9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
