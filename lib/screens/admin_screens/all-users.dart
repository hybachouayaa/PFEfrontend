import 'package:babysitter/config.dart';
import 'package:flutter/material.dart';
import 'package:babysitter/screens/admin_screens/services/admin_service.dart';
import 'package:babysitter/screens/auth/models/babysitter_model.dart';
import 'package:babysitter/screens/auth/models/parent_model.dart';
import 'package:babysitter/widgets/custom_scaffold.dart';
import 'package:http/http.dart' as http;

class BabysitterPage extends StatefulWidget {
  const BabysitterPage({super.key});

  @override
  _BabysitterPageState createState() => _BabysitterPageState();
}

class _BabysitterPageState extends State<BabysitterPage> {
  late Future<List<BabysitterModel>> futureBabysitters;
  late Future<List<ParentModel>> futureParents;

  @override
  void initState() {
    super.initState();
    futureBabysitters = AdminService().fetchBabysitters();
    futureParents = AdminService().fetchParents();
  }

  Future<void> _deleteBabysitter(String id, int index) async {
    final response = await http.delete(
      Uri.parse('http://${Config.ipAddress}:3000/api/babysitters/Delete/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Babysitter deleted successfully.');
      setState(() {
        futureBabysitters = AdminService().fetchBabysitters();
      });
    } else {
      print('Failed to delete babysitter: ${response.reasonPhrase}');
    }
  }

  Future<void> _deleteParent(String id, int index) async {
    final response = await http.delete(
      Uri.parse('http://${Config.ipAddress}:3000/api/parents/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Parent deleted successfully.');
      setState(() {
        futureParents = AdminService().fetchParents();
      });
    } else {
      print('Failed to delete parent: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Babysitters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<BabysitterModel>>(
                        future: futureBabysitters,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No babysitters found'));
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final babysitter = snapshot.data![index];
                                return Dismissible(
                                  key: Key(babysitter.id),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    _deleteBabysitter(babysitter.id, index);
                                  },
                                  child: ListTile(
                                    title: Text(
                                        '${babysitter.nom} ${babysitter.prenom}'),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Parents',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<ParentModel>>(
                        future: futureParents,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No parents found'));
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final parent = snapshot.data![index];
                                return Dismissible(
                                  key: Key(parent.id),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    _deleteParent(parent.id, index);
                                  },
                                  child: ListTile(
                                    title:
                                        Text('${parent.nom} ${parent.prenom}'),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
