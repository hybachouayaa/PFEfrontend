import 'dart:convert';
import 'dart:io';
import 'package:babysitter/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:babysitter/screens/admin_screens/services/admin_service.dart';
import 'package:babysitter/screens/auth/models/babysitter_model.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class AdminOffreDetailsPage extends StatefulWidget {
  final BabysitterModel user;
  const AdminOffreDetailsPage({super.key, required this.user});

  @override
  _AdminOffreDetailsPageState createState() => _AdminOffreDetailsPageState();
}

class _AdminOffreDetailsPageState extends State<AdminOffreDetailsPage> {
  String? _pdfPath;

  Future<void> acceptBabysitter(String id) async {
    final url = Uri.parse(
        'http://${Config.ipAddress}:3000/api/babysitters/accepte-babysitter/$id');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Babysitter accepted successfully.');
      } else if (response.statusCode == 404) {
        print('Babysitter not found.');
      } else {
        print('Failed to accept babysitter: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _loadCV() async {
    final response = await http.post(
      Uri.parse('http://${Config.ipAddress}:3000/api/babysitters/getCVById'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'id': widget.user.id}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final base64PDF = data['cv'];

      final bytes = base64Decode(base64PDF);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/cv.pdf');
      await file.writeAsBytes(bytes);

      setState(() {
        _pdfPath = file.path;
      });
    } else {
      print(
          'Failed to load CV for babysitter ${widget.user.id}: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCV();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8CDF9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.bell,
                    ),
                    onPressed: () {
                      print("Notifications icon tapped!");
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/Profile_Image.png'),
                        radius: 30,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.user.nom} ${widget.user.prenom}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.grey[600],
                                size: 18,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                widget.user.phone,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        widget.user.email,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ListView(
                    children: [
                      const Text(
                        'Détails',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.user.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_pdfPath != null) ...[
                        const Text(
                          'CV:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 400, // Set the desired height here
                          child: PDFView(
                            filePath: _pdfPath!,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await AdminService().accepetDemandes();
                              await acceptBabysitter(widget.user.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(150, 50),
                            ),
                            child: const Text(
                              'Accept',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async {
                              await AdminService().refuseDemandes();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(150, 50),
                            ),
                            child: const Text(
                              'Reject',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
