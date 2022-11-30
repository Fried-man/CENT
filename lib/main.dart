import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genome_2133/tabs/saved.dart';

import 'firebase_options.dart';
import 'home.dart';
import 'tabs/login.dart';

User? user;

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();

  user = FirebaseAuth.instance.currentUser;

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CENT - Exploration Tool',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        dialogBackgroundColor: const Color(0xffcccccc),
        scaffoldBackgroundColor: const Color(0xff445756),
        cardColor: const Color(0xff708f8d),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const Login(),
        '/saved': (context) => const Saved(),
      }));
}
