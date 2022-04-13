import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID Genome',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _Home();
}

class _Home extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerButton("Select Region(s)", (){}, context),
                  headerButton("Contact Us", (){}, context),
                  headerButton("FAQ", (){}, context),
                  headerButton("My Saved", (){}, context),
                  headerButton("Login", (){}, context)
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                  "assets/images/map.jpg",
                  fit: BoxFit.cover
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget headerButton (String text, Function action, var context) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: action(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 50,
              color: Colors.black
            ),
          ),
        ),
      ),
    ),
  );
}
