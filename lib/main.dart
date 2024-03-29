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
          scaffoldBackgroundColor: const Color(0xff2B3E3D),
          secondaryHeaderColor: const Color(0xff445756),
          cardColor: const Color(0xff708f8d),
          textTheme: isDyslexic ? GoogleFonts.lexendDecaTextTheme() : GoogleFonts.nunitoSansTextTheme(),
          primaryColor: Colors.black,
          highlightColor: Colors.blue,
          primaryColorLight: Colors.white,
          brightness: Brightness.light
      ),
      "Dark Mode" :
      ThemeData(
          primarySwatch: buildMaterialColor(Colors.white24),
          dialogBackgroundColor: const Color(0xff3d3d3d),
          scaffoldBackgroundColor: Colors.black87,
          secondaryHeaderColor: const Color(0xff445756),
          cardColor: const Color(0xff2B3E3D),
          textTheme: isDyslexic ? GoogleFonts.lexendDecaTextTheme() : GoogleFonts.nunitoSansTextTheme(),
          primaryColor: Colors.white60,
          highlightColor: Colors.blue,
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

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}