import 'package:putzplan/Model/Model.dart';

import '../View/View.dart';
import 'package:flutter/material.dart';

class Controller extends StatefulWidget {
  @override
  _ControllerState createState() => _ControllerState();
}

//###################################################################################
//hier ist der relevante Code:

class _ControllerState extends State<Controller> {
  late View view;
  late Model model;

  late Future authenticated;
  late Future listData;
  late Future loggedOut;

  @override
  void initState() {
    view = new View(context, setAbsent, fetchLogs, refresh, update, logout);
    model = new Model();
    authenticated = model.authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return controllerFuture(authenticated, 'trying to authenticate...', (data) {
      if (data) {
        return view.buildLogInScreen(evaluateAccessData);
      } else {
        listData = model.getData();
        return controllerFuture(listData, 'loading data...',
            (data) => view.buildPutzListScreen(data));
      }
    });
  }

  evaluateAccessData(username, password) async {
    //TODO: show login failed dialog
    this.setState(() {
      authenticated = model.evaluateAccessData(username, password);
      this.didChangeDependencies();
    });
    if (await authenticated) {
      view.buildDialog("Benutzername oder Passwort sind falsch!");
    }
  }

  logout() {
    setState(() {
      this.loggedOut = model.logout();
      this.build(context);
    });
  }

  Widget controllerFuture(
      Future future, String loadingMessage, Function function) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return view.buildLoadingScreen(loadingMessage);
          } else if (snapshot.hasData) {
            return function(snapshot.data);
          } else {
            return view.buildLoadingScreen(loadingMessage);
          }
        });
  }

  Future<void> refresh() async {}

  Future fetchLogs() {
    return Future.delayed(const Duration(seconds: 0), () => 'testData');
  }

  Future fetchData() {
    return Future.delayed(const Duration(seconds: 0), () => 'testData');
  }

  setAbsent(int userID, bool absent) {
    print(userID.toString() + absent.toString());
  }

  update(int taskID) {
    print(taskID.toString());
  }
}
