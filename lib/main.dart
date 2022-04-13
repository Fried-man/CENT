import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID Genome',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/home',
      routes: {
        '/home' : (context) => const Home(),
      }
    )
  );
}
