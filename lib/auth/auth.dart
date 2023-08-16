import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_material/auth/login_or_register.dart';
import 'package:social_media_material/pages/home_page.dart';

import '../pages/main_page.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot) {
          //user logged in
          if(snapshot.hasData)
            {
              return const MainPage();
            }
          //user not logged in
          else
          {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
