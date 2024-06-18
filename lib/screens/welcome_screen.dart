import 'package:babysitter/screens/auth/form_screen.dart';
import 'package:flutter/material.dart';

import 'package:babysitter/screens/auth/signup_screen.dart';
import 'package:babysitter/widgets/custom_scaffold.dart';
import 'package:babysitter/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 300.0), //espacement vertical
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          // TextSpan(
                          //     text: '\n\n\n\n',
                          ////    style: TextStyle(
                          //    fontSize: 45.0,
                          //      fontWeight: FontWeight.w600,
                          //    )),
                          //  TextSpan(
                          //    text: 'Welcome Back!\n',
                          //    style: TextStyle(
                          //      fontSize: 45.0,
                          //     fontWeight: FontWeight.w600,
                          //    color: Color(0xFFB542FE),
                          //   )),
                          TextSpan(
                              text:
                                  '\n\n\n\n\n\n\n\n\nEnter personal details to access to your account',
                              style: TextStyle(
                                color: Color(0xFFB542FE),
                                fontSize: 15,
                                // height: 0,
                              ))
                        ],
                      ),
                    ),
                  ),
                )),
          ),
          const Flexible(
            flex: 3,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Baby-sitter',
                      onTap: FormScreen(
                        type: 'baby-sitter',
                      ),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Parent',
                      onTap: SignUpScreen(
                        type: "parent",
                      ),
                      color: Colors.white,
                      textColor: Color(0xFFB542FE),
                    ),
                  ),
                  //Expanded(
                  //   child: WelcomeButton(
                  //     buttonText: 'Profile',
                  //     onTap: const ProfileScreen(),
                  //     color: Colors.white,
                  //    textColor: Color(0xFFB542FE),
                  //   ),
                  //   ),
                  //                    Expanded(
                  //   child: WelcomeButton(
                  //      buttonText: 'HomeScreen',
                  //     onTap:  HomeScreen(),
                  //     color: Colors.white,
                  //     textColor: Color(0xFFB542FE),
                  //    ),
                  //  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
