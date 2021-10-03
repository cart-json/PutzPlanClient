import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ListAppBar.dart';
import 'RefreshList.dart';

class PPListView extends StatefulWidget {
  final Function logout;
  final Function setPresence;
  final Function showLogs;
  final Future<void> Function() refresh;
  final Function setTaskDone;
  Map<String, dynamic> data;

  PPListView(
      {Key key,
      this.logout,
      this.setPresence,
      this.showLogs,
      this.refresh,
      this.setTaskDone,
      this.data})
      : super(key: key);

  setData(data) {
    this.data = data;
  }

  @override
  _PPListViewState createState() => _PPListViewState();
}

class _PPListViewState extends State<PPListView> {
  String title;
  PageController _controller;
  Map<String, dynamic> currentUser;

  initState() {
    super.initState();
    currentUser = widget.data['currentUser'];
    title = currentUser['mainTask'];
    _controller = PageController(
      initialPage: 0,
    );
  }

  Widget build(BuildContext context) {
    List subTasks = widget.data['subTasks'];
    List users = widget.data['users'];
    List lastWeek = widget.data['lastWeek'];
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
                list: subTasks,
                key: UniqueKey(),
                function: (Map<String, dynamic> response) =>
                    widget.setTaskDone(response),
                dialog: (String text) => "Für " + text + " erklären?"),
            RefreshList(
                refresh: widget.refresh,
                colored: (row) => !row['absent'],
                list: users,
                key: UniqueKey(),
                function: (Map<String, dynamic> response) =>
                    widget.setPresence(response),
                dialog: (String text1, String text2) =>
                    text1 + " für " + text2 + " erklären?"),
            RefreshList(
              refresh: widget.refresh,
              colored: (row) => row['points'] >= 20,
              list: lastWeek,
              key: UniqueKey(),
            ),
          ],
        ));
  }

  rebuild(data) {
    this.setState(() {
      data = data;
    });
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
    widget.setPresence(currentUser['id'], absent);
  }
}
