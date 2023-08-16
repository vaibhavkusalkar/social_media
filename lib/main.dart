import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_material/auth/auth.dart';
import 'package:social_media_material/firebase_options.dart';
import 'package:social_media_material/pages/comments_page.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // status bar color
    statusBarIconBrightness: Brightness.dark,  //status bar text color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic)
        {
          return MaterialApp(
              theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: lightDynamic
              ),
              debugShowCheckedModeBanner: false,
              home: AuthPage(),
          );
        }
    );
  }
}


