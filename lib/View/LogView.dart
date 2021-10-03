import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogView extends StatelessWidget {
  final Map<int, List<Map>> weekdayLogs;

  LogView({this.weekdayLogs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs'),
      ),
      body: _buildWeekdayList(),
    );
  }

  Widget _buildWeekdayList() {
    return ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(2),
        itemBuilder: (BuildContext _context, int i) {
          if (weekdayLogs[i] == null) {
            return SizedBox.shrink();
          } else {
            return _buildWeekdayRow(i, weekdayLogs[i]);
          }
        });
  }

  //anklickbare Taskbar mit Informationen zur Aufgabe
  Widget _buildWeekdayRow(int weekday, List<Map> logs) {
    return Card(
        //color: Colors.blue.shade300,
        child: Column(
      children: [
        Text(
            (() {
              switch (weekday) {
                case 0:
                  return 'Montag';
                case 1:
                  return 'Dienstag';
                case 2:
                  return 'Mittwoch';
                case 3:
                  return 'Donnerstag';
                case 4:
                  return 'Freitag';
                case 5:
                  return 'Samstag';
                case 6:
                  return 'Sonntag';
              }
              return '';
            }()),
            style: TextStyle(fontSize: 17)),
        ListView.builder(
            itemCount: logs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(2),
            itemBuilder: (BuildContext _context, int i) {
              return _buildLogRow(logs[i]);
            }),
      ],
    ));
  }

  //anklickbare Taskbar mit Informationen zur Aufgabe
  Widget _buildLogRow(Map log) {
    return Card(
        child: ListTile(
            title:
                Text(log['userName'] + ' hat "' + log['task'] + '" erledigt'),
            subtitle: Text(log['mainTask'] +
                ' ' +
                log['time']['hour'].toString().padLeft(2, '0') +
                ':' +
                log['time']['minute'].toString().padLeft(2, '0'))));
  }
}
