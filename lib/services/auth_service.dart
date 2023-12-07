import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/onboard/onboard_screen.dart';

class AuthServiceListener extends StatelessWidget {
  const AuthServiceListener({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const OnboardScreen();
          }
        });
  }
}
