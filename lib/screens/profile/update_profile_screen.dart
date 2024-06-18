import 'package:babysitter/screens/profile/services/update_profile_service.dart';
import 'package:flutter/material.dart';


class UptadeProfileScreen extends StatelessWidget {
  const UptadeProfileScreen({super.key});

  // final Map<String, dynamic>? user;
  // const UptadeProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    TextEditingController nomontroller = TextEditingController();
    TextEditingController prenomontroller = TextEditingController();
    TextEditingController emailontroller = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nbEnfantsController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Profile', style: TextStyle(fontSize: 20)),
        ),
        actions: [
          Container(width: 48),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: nomontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter nom';
                }
                return null;
              },
              decoration: InputDecoration(
                label: const Text('Nom'),
                hintText: 'Enter nom',
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
              height: 20.0,
            ),
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
                hintText: 'Enter prenom',
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
              height: 20.0,
            ),
            // email
            TextFormField(
              controller: emailontroller,
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
              height: 20.0,
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.number,
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
              height: 20.0,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              obscuringCharacter: '*',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
              decoration: InputDecoration(
                label: const Text('Password'),
                hintText: 'Enter Password',
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
              controller: nbEnfantsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: const Text('Number of Children'),
                hintText: 'Enter the number of children',
                hintStyle: const TextStyle(color: Colors.black26),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var result = await UptadeProfile().updateAccount(
                      nomontroller.text,
                      prenomontroller.text,
                      emailontroller.text,
                      phoneController.text,
                      passwordController.text,
                      nbEnfantsController.text);

                  if (result == 'succes') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Success'),
                      ),
                    );
                  }else{
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error'),
                      ),
                    );
                  }
                },
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
