import 'package:flutter/material.dart';
import 'LoadingScreen.dart';
import 'PPListView.dart';
import 'LoginScreen.dart';
import 'LogView.dart';

class View {
  BuildContext context;

  final Function setPresence;
  final Function showLogs;
  final Future<void> Function() refresh;
  final Function logout;
  final Function setTaskDone;

  View(
      {this.context,
      this.setPresence,
      this.showLogs,
      this.refresh,
      this.logout,
      this.setTaskDone});

  Widget buildLogInScreen(Function evaluateAccessData) {
    return LoginScreen(evaluateAccessData).build(context);
  }

  Widget buildPutzListScreen(Map<String, dynamic> data) {
    var view = PPListView(
        key: UniqueKey(),
        logout: logout,
        setPresence: requestSetPresence,
        showLogs: showLogs,
        refresh: refresh,
        setTaskDone: requestTaskDone,
        data: data);
    return PPListView(
        key: UniqueKey(),
        logout: logout,
        setPresence: requestSetPresence,
        showLogs: showLogs,
        refresh: refresh,
        setTaskDone: requestTaskDone,
        data: data);
  }

  Widget buildLogScreen(data) {
    return LogView(
      weekdayLogs: data,
    );
  }

  Widget buildLoadingScreen(String text) {
    return LoadingScreen(text);
  }

  buildDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  buildDecisionDialog(
      String text, Function function, Map<String, dynamic> response) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text),
            actions: [
              TextButton(
                  onPressed: () {
                    function(response);
                    Navigator.of(context).pop();
                  },
                  child: Text("Ja")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Nein")),
            ],
          );
        });
  }

  requestSetPresence(Map<String, dynamic> response) {
    buildDecisionDialog(
        (response['name'].toString() +
            ' für ' +
            (response['absent'] ? 'abwesend' : 'anwesend') +
            'erklären'),
        setPresence,
        response);
  }

  requestTaskDone(Map<String, dynamic> response) {
    buildDecisionDialog(
        ('Aufgabe ' + response['name'].toString() + ' erledigt?'),
        setTaskDone,
        response);
  }
}
