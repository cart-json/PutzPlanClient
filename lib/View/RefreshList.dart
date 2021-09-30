import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshList extends StatelessWidget {
  final Future<void> Function() refresh;
  final Function(Map<String, dynamic>) colored;
  final void Function(dynamic, dynamic)? function;

  final List<Map> list;

  const RefreshList(
      {required Key key,
      required this.refresh,
      required this.colored,
      required this.list,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      //ListViewBuilder erstellt einen Listeneintrag für alle Aufgaben
      child: ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(2),
          itemBuilder: (BuildContext _context, int i) {
            return _buildRow(context, list[i] as Map<String, dynamic>);
          }),
    );
  }

  Widget _buildRow(context, Map<String, dynamic> row) {
    return Card(
        child: ListTile(
            trailing: Text(
              row['points'].toString(),
            ),
            title: Text(
              row['name'],
              style:
                  TextStyle(color: (colored(row) ? Colors.black : Colors.red)),
            ),
            subtitle: Text(row['mainTask']),
            onTap: () => function!));
  }
}
