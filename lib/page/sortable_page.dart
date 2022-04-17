import 'package:genome_2133/data/variants.dart';
import 'package:genome_2133/model/variant.dart';
import 'package:genome_2133/widget/scrollable_widget.dart';
import 'package:flutter/material.dart';

class SortablePage extends StatefulWidget {
  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  late List<Variant> users;
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();

    this.users = List.of(allUsers);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    final columns = ['Accession', 'Geographical Location', 'Date Collected', 'Pinned'];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(users),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            tooltip: 'Column represents the ${Text(column).data}',
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<Variant> users) => users.map((Variant user) {
        final cells = [user.accession, user.geoLocation, user.collectionDate];
        List<DataCell> lister = getCells(cells);
        DataCell pinner = const DataCell (
            Icon(
              Icons.push_pin,
              color: Colors.green,
            )
        );
        if (user.pinned == 'not') {
          pinner = const DataCell (
              Icon(
                  Icons.panorama_fish_eye,
                  color: Colors.red
              )
          );
        }

        lister.add(pinner);
        return DataRow(cells: lister);
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      users.sort((user1, user2) =>
          compareString(ascending, user1.accession, user2.accession));
    } else if (columnIndex == 1) {
      users.sort((user1, user2) =>
          compareString(ascending, user1.geoLocation, user2.geoLocation));
    } else if (columnIndex == 2) {
      users.sort((user1, user2) =>
          compareString(ascending, '${user1.collectionDate}', '${user2.collectionDate}'));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
