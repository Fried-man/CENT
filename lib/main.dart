import 'package:flutter/material.dart';
import 'package:genome_2133/tabs/saved.dart';

import 'home.dart';
import 'tabs/login.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
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
