// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

//import 'package:babysitter/widgets/NavBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE8CDF9),
      //   bottomNavigationBar: (NavBar()),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi Hyba !',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '17 april,2024',
                            style: TextStyle(
                              color: Colors.grey[200],
                            ),
                          )
                        ],
                      ),
                      Container(
                          child: Icon(Icons.notifications_active_outlined)),
                    ],
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  // search bar
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text('Search'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20, // Taille de l'espace
            ),
            Expanded(
              child: ClipRRect(
                //borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: EdgeInsets.all(25),
                  color: Colors.grey[100],
                  // Votre contenu ici
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Baby-sitters',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            Icon(Icons.more_horiz),
                          ],
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        //listview of baby sitters
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/Profile_Image.png'),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //title
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rahma Ben Ahmed',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //subtitle
                                  Text(
                                    '40dt/heure , Sousse',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
