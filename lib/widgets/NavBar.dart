import 'package:babysitter/screens/home_screen/homescreen.dart';
import 'package:babysitter/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  final _pages = [
    const Center(child: Text('Home')),
    const Center(child: Text('Message')),
    const Center(child: Text('Fav List')),
    const Center(child: Text('Profile')),
  ];

  void _changePageTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      backgroundColor: Colors.white,
      //  floatingActionButton: FloatingActionButton(
      //      onPressed: () {},
      //    child: const Icon(
      //     CupertinoIcons.plus_circled,
      //    color: Colors.white,
      //   ),
      //   ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 80.0,
        width: double.infinity,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 19.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 15.0,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_pages.length, (index) {
            return GestureDetector(
              onTap: () {
                _changePageTo(index);
                if (index == 3) {
                  // Check if profile icon is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen(type: "",)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }
              },
              child: Icon(
                index == _selectedIndex
                    ? _getSelectedIcon(index)
                    : _getUnselectedIcon(index),
                color: index == _selectedIndex ? Colors.purple : Colors.black,
              ),
            );
          }),
        ),
      ),
    );
  }

  IconData _getSelectedIcon(int index) {
    switch (index) {
      case 0:
        return CupertinoIcons.home;
      case 1:
        return CupertinoIcons.chat_bubble_2;
      case 2:
        return CupertinoIcons.heart;
      case 3:
        return CupertinoIcons.profile_circled;
      default:
        return CupertinoIcons.home;
    }
  }

  IconData _getUnselectedIcon(int index) {
    switch (index) {
      case 0:
        return CupertinoIcons.home;
      case 1:
        return CupertinoIcons.chat_bubble_2;
      case 2:
        return CupertinoIcons.heart;
      case 3:
        return CupertinoIcons.profile_circled;
      default:
        return CupertinoIcons.home;
    }
  }
}
