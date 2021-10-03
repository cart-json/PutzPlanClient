import 'package:putzplan/Model/Model.dart';

import '../View/View.dart';
import 'package:flutter/material.dart';

class Controller extends StatefulWidget {
  @override
  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  View view;
  Model model;

  Future authenticated;
  Future listData;
  Future loggedOut;
  Future logs;

  @override
  void initState() {
    view = new View(
        context: context,
        setPresence: setPresence,
        showLogs: showLogs,
        refresh: refresh,
        logout: logout,
        setTaskDone: setTaskDone);
    model = new Model();
    authenticated = model.authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return controllerFuture(authenticated, 'trying to authenticate...', (data) {
      if (!data) {
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
    bool auth = await authenticated;
    if (auth) {
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

  Future<void> refresh() async {
    listData = model.getData();
    setState(() {
      this.build(context);
    });
  }

  showLogs() {
    logs = model.getLogs();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return controllerFuture(
          logs, 'loading data...', (data) => view.buildLogScreen(data));
    }));
  }

  Future fetchData() {
    return Future.delayed(const Duration(seconds: 0), () => 'testData');
  }

  setPresence(Map<String, dynamic> request) {
    print(request['id'].toString() +
        ' goes ' +
        (request['absent'] ? 'present' : 'absent'));
  }

  setTaskDone(Map<String, dynamic> request) async {
    var result = await model.update(request['id']);
    if (result['failed']) {
      view.buildDialog(
          'Something went wrong, please try again or contact out customer support');
    } else {
      this.refresh();
    }

    print(request['id'].toString() + ' is done');
  }
}
