// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:babysitter/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class CalendrierRendezVousPage extends StatefulWidget {
  final String babysitterName;

  const CalendrierRendezVousPage({super.key, required this.babysitterName});
  @override
  _CalendrierRendezVousPageState createState() =>
      _CalendrierRendezVousPageState();
}

Map<String, dynamic>? parent = GetStorage().read('parent');
Map<String, dynamic>? baby_sitter = GetStorage().read('babysitter');

class _CalendrierRendezVousPageState extends State<CalendrierRendezVousPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<dynamic> rendezVousList2 =
      []; // Initialise _selectedDay à la date actuelle

  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  List<Map<String, dynamic>> parentDataList = [];

  void _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _selectedStartTime : _selectedEndTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = picked;
        } else {
          _selectedEndTime = picked;
        }
      });
    }
  }

  getFCMToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("houniiiiiii $mytoken");
  }

  Future<Map<String, dynamic>?> getParentByToken(String token) async {
    final url = 'http://${Config.ipAddress}:3000/api/parents/$token';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load parent: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching parent data: $error');
      return null;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenPR');
  }

  Future<String?> getParentIdByToken(String token) async {
    final url = 'http://${Config.ipAddress}:3000/api/parents/$token';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data[
            '_id']; // Assurez-vous que l'ID est bien contenu dans le champ '_id' ou utilisez le nom correct du champ.
      } else {
        print('Failed to load parent: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error fetching parent data: $error');
      return null;
    }
  }

  void _sendRendezVous() async {
    try {
      final String? babysitterToken = await FirebaseMessaging.instance
          .getToken(); // Récupérer le token FCM du babysitter
      final String? parentToken =
          await getToken(); // Récupérer le token FCM du parent depuis le stockage
      final String? parentId = await getParentIdByToken(parentToken!);
      print(widget.babysitterName);

      if (parentDataList.isNotEmpty) {
        final parentData = parentDataList[0]; // Accéder au premier élément

        final String apiUrl =
            'http://${Config.ipAddress}:3000/api/parents/$parentId/${widget.babysitterName}/rendezvous';
        print("${widget.babysitterName}  ##########################");
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'date': _selectedDay.toIso8601String(), // Envoyer la date
            'heure_debut':
                '${_selectedStartTime.hour}:${_selectedStartTime.minute}', // Envoyer l'heure de début au format HH:mm
            'heure_fin':
                '${_selectedEndTime.hour}:${_selectedEndTime.minute}', // Envoyer l'heure de fin au format HH:mm
            'nomParent': parentData['nom'],
            'fcm_token': fcmToken // Utiliser les données de parentData
          }),
        );

        if (response.statusCode == 201) {
          // await sendNotification(
          //     babysitterToken); // Utiliser le token FCM du babysitter
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rendez-vous envoyé avec succès!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Une erreur s\'est produite lors de l\'envoi du rendez-vous.'),
              backgroundColor: Colors.red,
            ),
          );
          print(response.body);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucune donnée parent trouvée.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Une erreur s\'est produite lors de l\'envoi du rendez-vous.'),
          backgroundColor: Colors.red,
        ),
      );
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchParentData();
    _fetchRendezVous();
    sendFCMToken();

    getFCMToken();
  }

  Future<void> addRendezVous() async {
    final String? parentToken =
        await getToken(); // Récupérer le token FCM du parent depuis le stockage
    final String? parentId = await getParentIdByToken(parentToken!);
    final url = Uri.parse(
        'http://${Config.ipAddress}:3000/api/parents/$parentId/${widget.babysitterName}/rendezvous');
    final parentData = parentDataList[0]; // Accéder au premier élément
    String? fcmToken = await sendFCMToken();
    if (fcmToken != null) {
      // FCM token récupéré avec succès
    } else {
      // Échec de la récupération du FCM token
    }

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'date': _selectedDay.toIso8601String(), // Envoyer la date
          'heure_debut':
              '${_selectedStartTime.hour}:${_selectedStartTime.minute}', // Envoyer l'heure de début au format HH:mm
          'heure_fin':
              '${_selectedEndTime.hour}:${_selectedEndTime.minute}', // Envoyer l'heure de fin au format HH:mm
          'nomParent': parentData['nom'],
          'fcm_token': fcmToken!,
        }),
      );

      if (response.statusCode == 201) {
        print('Rendez-vous ajouté avec succès');
      } else {
        print('Erreur lors de l\'ajout du rendez-vous: ${response.body}');
      }
    } catch (error) {
      print('Erreur lors de l\'ajout du rendez-vous: $error');
    }
  }

  Future<void> _fetchRendezVous() async {
    try {
      final List<dynamic> data =
          await getRendezVousByBabysitterId(widget.babysitterName);
      setState(() {
        rendezVousList2 = data;
      });
    } catch (error) {
      print('Error fetching rendezvous: $error');
    }
  }

  Future<List<dynamic>> getRendezVousByBabysitterId(String babysitterId) async {
    final url =
        'http://${Config.ipAddress}:3000/api/babysitters/rendezVousId/$babysitterId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load rendezvous: ${response.statusCode}');
    }
  }

  Future<void> _fetchParentData() async {
    final String? token = await getToken();
    if (token != null) {
      final data = await getParentByToken(token);
      if (data != null) {
        setState(() {
          parentDataList.add(data);
        });
      }
    }
  }

  Future<String?> sendFCMToken() async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      // Définissez l'URL de votre endpoint sur le serveur
      final url = Uri.parse(
          'http://${Config.ipAddress}:3000/api/babysitters/updateFCMToken');

      // Créez le corps de la requête avec le token et le fcmToken
      final body =
          jsonEncode({'id': widget.babysitterName, 'fcmToken': fcmToken});

      // Envoyez une requête POST au serveur avec le corps JSON
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Vérifiez si la requête a réussi
      if (response.statusCode == 200) {
        print('FCM token updated successfully.');
        return fcmToken; // Retournez le FCM token
      } else {
        print('Failed to update FCM token: ${response.body}');
        return null; // Retournez null en cas d'échec
      }
    } catch (error) {
      print('An error occurred while sending FCM token: $error');
      return null; // Retournez null en cas d'erreur
    }
  }

  Future<void> sendNotification(String? token) async {
    if (token == null) {
      print("FCM token is null");
      return;
    }

    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAkrZ33uU:APA91bFmD8g0KJw7pwsSCXxq5tbLnh8WCYqsR4-LvwooC1ASL5hSLUkYtGSCJ2U4-IWHNl1YinHkOhZK991jHwQG9JV1VbNAII2LOX-TWa7t2fHA0TpCTnxHaEEHS5rd52ia5GFj8uuL',
    };

    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": token,
      "notification": {
        "title": "Réservation",
        "body": "merci de recouvrer",
        "mutable_content": true,
        "sound": "Tri-tone"
      }
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      print(token);
      print("mriiiiiiiiiiiiiiiiiiiiiigl");
    } else {
      print(res.reasonPhrase);
    }
  }

  String message = "";

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      Map? pushArguments = arguments as Map;
      setState(() {
        message = pushArguments["message"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier des rendez-vous'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectTime(context, true),
                    child: Text('Début: ${_selectedStartTime.format(context)}'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, false),
                    child: Text('Fin: ${_selectedEndTime.format(context)}'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => addRendezVous(),
                child: const Text('Envoyer le rendez-vous'),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Le/la babysitter n'est pas disponible pour ces dates.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Heure de début')),
                  DataColumn(label: Text('Heure de fin')),
                ],
                rows: rendezVousList2.map((rendezVousItem) {
                  return DataRow(cells: [
                    DataCell(Text(rendezVousItem['date'])),
                    DataCell(Text(rendezVousItem['heure_debut'])),
                    DataCell(Text(rendezVousItem['heure_fin'])),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
