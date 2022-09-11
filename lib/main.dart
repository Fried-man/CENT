import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genome_2133/tabs/saved.dart';

import 'home.dart';
import 'tabs/login.dart';

User? user = FirebaseAuth.instance.currentUser;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions( // TODO: import from index.html
      apiKey: "AIzaSyBtGFwfR45P_psP3yYtibqlijhDJ0J02Oc",
      appId: "1:29922646312:web:3d58b6360aa66789f2d81d",
      messagingSenderId: "29922646312",
      projectId: "genome-e2802",
    ),
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID Genome',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        dialogBackgroundColor: const Color(0xffcccccc),
        scaffoldBackgroundColor: const Color(0xff445756),
      ),
      initialRoute: '/home',
      routes: {
        '/home' : (context) => const Home(),
        '/login' : (context) => const Login(),
        '/saved' : (context) => const Saved(),
      }
    )
  );
}
