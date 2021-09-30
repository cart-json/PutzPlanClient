/*import 'package:flutter/material.dart';

import 'Model/Log.dart';
import 'Model/SubTask.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Putzplan',
    );
  }
// #enddocregion build
}

class Test extends StatefulWidget {
  const Test({Key key, this.number}) : super(key: key);

  final int number;

  @override
  _TestState createState() => _TestState();
}

//###################################################################################
//hier ist der relevante Code:

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class ServerMock {
  static Map<int, List<Log>> fetchLogs() {
    Map listJson = {
      "logs": [
        {
          "actualUser": "Leo",
          "mainTask": "Böden",
          "pointsGained": 5,
          "task": "Saugen",
          "time": "2021-09-14 18:32:33.669021",
          "userID": 3,
          "userName": "Leo"
        },
        {
          "actualUser": "Clemens",
          "mainTask": "Küche",
          "pointsGained": 1,
          "task": "Müll",
          "time": "2021-09-13 18:32:52.960687",
          "userID": 1,
          "userName": "Leo"
        },
        {
          "actualUser": "Clemens",
          "mainTask": "Küche",
          "pointsGained": 1,
          "task": "Oberflächen, Spüle",
          "time": "2021-09-14 18:32:54.843353",
          "userID": 1,
          "userName": "Clemens"
        },
        {
          "actualUser": "Nick",
          "mainTask": "Bad-unten",
          "pointsGained": 6,
          "task": "Duschkabine",
          "time": "2021-09-13 18:33:04.716478",
          "userID": 4,
          "userName": "Nick"
        },
        {
          "actualUser": "Nick",
          "mainTask": "Bad-unten",
          "pointsGained": 2,
          "task": "Müll",
          "time": "2021-09-15 18:33:06.463847",
          "userID": 4,
          "userName": "Nick"
        },
        {
          "actualUser": "Robin",
          "mainTask": "Putzen",
          "pointsGained": 3,
          "task": "Wohnzimmer abstauben",
          "time": "2021-09-19 18:33:17.566823",
          "userID": 5,
          "userName": "Robin"
        },
        {
          "actualUser": "Johannes",
          "mainTask": "Bad-oben",
          "pointsGained": 6,
          "task": "Duschkabine",
          "time": "2021-09-16 18:33:26.304875",
          "userID": 2,
          "userName": "Johannes"
        },
        {
          "actualUser": "Johannes",
          "mainTask": "Bad-oben",
          "pointsGained": 2,
          "task": "Waschbecken",
          "time": "2021-09-19 18:33:27.593053",
          "userID": 2,
          "userName": "Johannes"
        },
        {
          "actualUser": "Leo",
          "mainTask": "Bad-oben",
          "pointsGained": 6,
          "task": "Duschkabine",
          "time": "2021-09-17 20:48:17.894303",
          "userID": 3,
          "userName": "Leo"
        },
        {
          "actualUser": "Leo",
          "mainTask": "Bad-oben",
          "pointsGained": 2,
          "task": "Toilette",
          "time": "2021-09-18 20:48:20.457299",
          "userID": 3,
          "userName": "Leo"
        }
      ]
    };

    Map<int, List<Log>> weekList = {};
    List<Log> logList = Log.jsonToLogList(listJson['logs'] as List);
    logList.forEach((element) {
      var weekday = element.time.weekday - 1;
      if (weekList[weekday] == null) {
        weekList[weekday] = [];
      }
      weekList[weekday].add(element);
    });
    return weekList;
  }

  static Future<dynamic> update(int taskID) async {}

  static Future<dynamic> logIn(username, hashPW) async {}

  static Future<dynamic> authenticate(String authenticationKey) async {}

  static Future<dynamic> setAbsent(bool absent) {}

  static Future<dynamic> setAbsentByID(int userID, bool absent) {}
}*/