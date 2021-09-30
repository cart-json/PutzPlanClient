import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ListAppBar.dart';
import 'RefreshList.dart';

class PPListView extends StatefulWidget {
  final Function logout;
  final Function setAbsent;
  final Function showLogs;
  final Future<void> Function() refresh;
  final Function setTaskDone;
  final Map<String, dynamic> data;

  PPListView(
      {required Key key,
      required this.logout,
      required this.setAbsent,
      required this.showLogs,
      required this.refresh,
      required this.setTaskDone,
      required this.data})
      : super(key: key);

  @override
  _PPListViewState createState() => _PPListViewState();
}

class _PPListViewState extends State<PPListView> {
  late String title;
  late PageController _controller;
  late Map<String, dynamic> currentUser;

  initState() {
    super.initState();
    currentUser = widget.data['currentUser']!;
    title = currentUser['mainTask']!;
    _controller = PageController(
      initialPage: 0,
    );
  }

  Widget build(BuildContext context) {
    List<Map> subTasks = widget.data['subTasks']!;
    List<Map> users = widget.data['users']!;
    List<Map> lastWeek = widget.data['lastWeek'];
    return Scaffold(
        appBar: ListAppBar(
          () => goAbsent(currentUser['id']),
          widget.logout,
          widget.showLogs,
          currentUser['points'],
          currentUser['absent'],
          title,
        ),
        body: PageView(
          controller: _controller,
          onPageChanged: _setTitle,
          children: [
            RefreshList(
              refresh: widget.refresh,
              colored: (row) => row['mainTask'] == currentUser['mainTask'],
              list: subTasks!,
              key: UniqueKey(),
              function: (id, sns) => widget.setTaskDone(id),
            ),
            RefreshList(
              refresh: widget.refresh,
              colored: (row) => !row['absent'],
              list: users,
              key: UniqueKey(),
              function: (absent, id) => widget.setAbsent(id, absent),
            ),
            RefreshList(
              refresh: widget.refresh,
              colored: (row) => row['points'] >= 20,
              list: lastWeek,
              key: UniqueKey(),
            ),
          ],
        ));
  }

  void _setTitle(int page) {
    setState(() {
      switch (page) {
        case 0:
          title = currentUser['mainTask'];
          break;
        case 1:
          title = 'Nutzer aktuell';
          break;
        case 2:
          title = 'Überblick letzte Woche';
          break;
      }
      this.build(context);
    });
  }

  void goAbsent(bool absent) {
    widget.setAbsent(currentUser['id'], absent);
  }
}
