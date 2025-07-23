import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recommendation/Screens/AdminPanelScreen.dart';
import 'package:recommendation/Screens/HomeScreen.dart';
import 'package:recommendation/Screens/WelcomeScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> main() async {
  late final FirebaseApp app;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCd4KPl6cE0B9TnCejL5JSeyISzBdCy_Ww",
      appId: "1:1000804428461:android:a40cf7166fc84c78a53424",
      messagingSenderId: "1000804428461",
      projectId: "recommendation-e4436",
    ),
  );

  runApp(const MyApp());
}

final User? user = _auth.currentUser;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: AnimatedSplashScreen(
        splashIconSize: 200,
        splashTransition: SplashTransition.scaleTransition,
        splash: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 200,
          child: Image.asset("assets/images/logo.png", fit: BoxFit.cover),
        ),
        nextScreen:
            (user?.email != null && user?.email != "")
                ? user?.email == "admin@gmail.com"
                    ? AdminPanelScreen()
                    : HomeScreen()
                : WelcomeScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
