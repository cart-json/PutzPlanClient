import 'package:flutter/material.dart';
import 'LoadingScreen.dart';
import 'PPListView.dart';
import 'LoginScreen.dart';

class View {
  BuildContext context;

  final Function setAbsent;
  final Function showLogs;
  final Future<void> Function() refresh;
  final Function logout;
  final Function setTaskDone;

  View(this.context, this.setAbsent, this.showLogs, this.refresh, this.logout,
      this.setTaskDone) {}

  Widget buildLogInScreen(Function evaluateAccessData) {
    return LoginScreen(evaluateAccessData).build(context);
  }

  Widget buildPutzListScreen(Map<String, dynamic> data) {
    return PPListView(
        key: UniqueKey(),
        logout: logout,
        setAbsent: setAbsent,
        showLogs: showLogs,
        refresh: refresh,
        setTaskDone: setTaskDone,
        data: data);
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
}
