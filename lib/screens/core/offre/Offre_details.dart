import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfferDetailsPage extends StatelessWidget {
  const OfferDetailsPage({super.key});

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
                      Navigator.of(context)
                          .pop(); // Typically used to go back to the previous screen
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.bell,
                    ),
                    onPressed: () {
                      // Add the desired functionality for the notification bell here, e.g., open notifications view
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
                  // SizedBox(height: 5),
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
                          const Text(
                            'Rahma Ben Ahmed',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[600],
                                size: 18,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Sousse',
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        'Prix par heure: 40dt',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(height: 3),
                      //   Container(
                      //   padding:
                      //    EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      //  decoration: BoxDecoration(
                      //   color: Colors.grey[300],
                      //  borderRadius: BorderRadius.circular(8),
                      // ),
                      // child: Text(
                      // 'Experience: 5 years',
                      //  style: TextStyle(
                      //     fontSize: 14,
                      //    ),
                      //   ),
                      // ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Offer description goes here...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Add functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xffFFA500), //orange color
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Book Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          MaterialButton(
                              onPressed: () {
                                // Add functionality here
                              },
                              color: Colors.grey[300],
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(15),
                              child: IconButton(
                                icon: const Icon(
                                  CupertinoIcons.chat_bubble,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                onPressed: () {
                                  print('Icon button tapped!');
                                },
                              )),
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
