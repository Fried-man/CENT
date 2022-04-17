import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../page/sortable_page.dart';
import '../widget/tabbar_widget.dart';

class Saved extends StatefulWidget {
  static final String title = 'My Saved';
  const Saved({Key? key}) : super(key: key);

  @override
  State<Saved> createState() => _Saved();
}

class _Saved extends State<Saved> {

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'My Saved',
    theme: ThemeData(primarySwatch: Colors.grey),
    home: MainPage(),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => TabBarWidget(
    title: Saved.title,
    tabs: [
      Tab(icon: Icon(Icons.sort_by_alpha), text: 'Sort Variants'),
      //Tab(icon: Icon(Icons.select_all), text: 'Selectable'),
      //Tab(icon: Icon(Icons.edit), text: 'Editable'),
    ],
    children: [
      SortablePage(),
      //Container(),
      //Container(),
    ],
  );
}
