import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:google_fonts/google_fonts.dart';


import 'firebase_options.dart';
import 'home.dart';
import 'tabs/login.dart';

User? user;
bool isDesktop = (defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.windows) &&
    !kIsWeb;

bool isDyslexic = false;
bool isMapDisabled = false;
String theme = "Default";
late Map dict;
Map<String, dynamic> userData = {};


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  user = FirebaseAuth.instance.currentUser;

  if (FirebaseAuth.instance.currentUser != null) {
    userData = (await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get()).data()!;
    if (userData.containsKey("theme")) {
      theme = userData["theme"];
    }
    if (userData.containsKey("map disabled")) {
      isMapDisabled = userData["map disabled"];
    }
    if (userData.containsKey("dyslexic")) {
      isDyslexic = userData["dyslexic"];
    }
  }

  runApp(const MyApp());
}

class MyApp<T> extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState<T> extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      isDyslexic = false;
      isMapDisabled = false;
      theme = "Default";
      userData = {};
    }

    dict  = {
      "Default" :
      ThemeData(
          primarySwatch: Colors.grey,
          dialogBackgroundColor: const Color(0xffcccccc),
          scaffoldBackgroundColor: const Color(0xff445756),
          cardColor: const Color(0xff708f8d),
          textTheme: isDyslexic ? GoogleFonts.lexendDecaTextTheme() : GoogleFonts.nunitoSansTextTheme(),
          primaryColor: Colors.black,
          highlightColor: Colors.blue,
          primaryColorLight: Colors.white
      ),
      "Dark Mode" :
      ThemeData(
          primarySwatch: Colors.grey,
          dialogBackgroundColor: const Color(0xff3d3d3d),
          scaffoldBackgroundColor: Colors.black87,
          cardColor: Colors.blueGrey.shade800,
          textTheme: isDyslexic ? GoogleFonts.lexendDecaTextTheme() : GoogleFonts.nunitoSansTextTheme(),
          primaryColor: Colors.white,
          highlightColor: Colors.blue,
          primaryColorLight: Colors.white,
          brightness: Brightness.dark,
      ),
    };

    if ((defaultTargetPlatform == TargetPlatform.iOS && kIsWeb) || (defaultTargetPlatform == TargetPlatform.android && kIsWeb)) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CENT - Exploration Tool',
          theme: dict[theme],
          initialRoute: '/illegal',
          routes: {
            '/illegal': (context) => const Illegal()
          }
      );
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CENT - Exploration Tool',
        theme: dict[theme],
        initialRoute: '/home',
        routes: {
          '/home': (context) => const Home(),
          '/login': (context) => const Login(),
        }
    );
  }
}

class Illegal extends StatelessWidget {
  const Illegal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: SizedBox(
                height: min(MediaQuery.of(context).size.height / 2, MediaQuery.of(context).size.width / 2),
                width: min(MediaQuery.of(context).size.height / 2, MediaQuery.of(context).size.width / 2),
                child: Image.network('https://media1.giphy.com/media/3oKGzgNfssFG1xlwC4/giphy.gif'))
            ),
            const Text(
              "Please view on desktop.",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20
              ),
            ),
          ],
        )
    );
  }
}
