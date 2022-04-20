import 'package:flutter/material.dart';
import 'package:genome_2133/tabs/saved/page/sortable_page.dart';

import '../widget/tabbar_widget.dart';

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  State<Saved> createState() => _Saved();
}

class _Saved extends State<Saved> {
  @override
  Widget build(BuildContext context) =>  TabBarWidget(
    title: "My saved",
    tabs: const [Tab(icon: Icon(Icons.sort_by_alpha), text: 'Sort Variants')],
    children: [SortablePage()],
  );
}
