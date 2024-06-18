import 'package:babysitter/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RendezVousBabySitter extends StatefulWidget {
  final String type;

  const RendezVousBabySitter({super.key, required this.type});

  @override
  _RendezVousBabySitterState createState() => _RendezVousBabySitterState();
}

class _RendezVousBabySitterState extends State<RendezVousBabySitter> {
  List<dynamic> rendezVousList = [];

  getFCMToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("houniiiiiii $mytoken");
  }

  @override
  void initState() {
    super.initState();
    _fetchRendezVous();
    getFCMToken();
  }

  Future<void> _fetchRendezVous() async {
    List<dynamic> data = await getRendezVousByBabysitterId();
    print('Fetched rendezvous: $data'); // Debug print
    setState(() {
      rendezVousList = data;
    });
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenBB');
  }

  Future<List<dynamic>> getRendezVousByBabysitterId() async {
    final String? token = await getToken();
    final url =
        'http://${Config.ipAddress}:3000/api/babysitters/rendezVous/$token';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Response data: ${response.body}'); // Debug print
        return json.decode(response.body) as List<dynamic>;
      } else {
        print('Failed to load rendezvous: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching rendezvous: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DataColumn> columns = [
      const DataColumn(label: Text('Nom Parent')),
      const DataColumn(label: Text('Date')),
      const DataColumn(label: Text('Heure de début')),
      const DataColumn(label: Text('Heure de fin')),
    ];

    final List<DataRow> rows = rendezVousList.map<DataRow>((rendezVousItem) {
      return DataRow(
        cells: [
          DataCell(Text(rendezVousItem['nomParent'] ?? '')),
          DataCell(Text(rendezVousItem['date'] ?? '')),
          DataCell(Text(rendezVousItem['heure_debut'] ?? '')),
          DataCell(Text(rendezVousItem['heure_fin'] ?? '')),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendez-vous du Baby-Sitter'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}
