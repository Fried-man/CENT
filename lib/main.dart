import 'package:flutter/material.dart';

import 'faq.dart';
import 'home.dart';
import 'login.dart';

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
        '/faq' : (context) => const Faq(),
      }
    )
  );
}
