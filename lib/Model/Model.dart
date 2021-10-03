import 'ServerQueries.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model {
  Map<String, dynamic> testData = {
    "lastWeek": [
      {"mainTask": "Küche", "name": "Johannes", "points": 10},
      {"mainTask": "Bad-unten", "name": "Nick", "points": 15},
      {"mainTask": "Bad-oben", "name": "Robin", "points": 19},
      {"mainTask": "Böden", "name": "Clemens", "points": 20},
      {"mainTask": "Putzen", "name": "Leo", "points": 30}
    ],
    "currentUser": {
      "absent": false,
      "name": "Nick",
      "mainTask": "Bad-oben",
      "points": 0
    },
    "subTasks": [
      {"id": 11, "mainTask": "Bad-oben", "name": "Duschkabine", "points": 6},
      {"id": 12, "mainTask": "Bad-oben", "name": "Boden", "points": 6},
      {"id": 13, "mainTask": "Bad-oben", "name": "Toilette", "points": 2},
      {"id": 14, "mainTask": "Bad-oben", "name": "Müll", "points": 2},
      {"id": 15, "mainTask": "Bad-oben", "name": "Waschbecken", "points": 2},
      {"id": 16, "mainTask": "Böden", "name": "Saugen", "points": 5},
      {
        "id": 17,
        "mainTask": "Böden",
        "name": "Saugen und Wischen",
        "points": 10
      }
    ],
    "users": [
      {
        "absent": false,
        "id": 1,
        "mainTask": "Küche",
        "name": "Clemens",
        "points": 0
      },
      {
        "absent": false,
        "id": 2,
        "mainTask": "Bad-unten",
        "name": "Johannes",
        "points": 0
      },
      {
        "absent": false,
        "id": 4,
        "mainTask": "Bad-oben",
        "name": "Nick",
        "points": 0
      },
      {
        "absent": true,
        "id": 5,
        "mainTask": "Böden",
        "name": "Robin",
        "points": 0
      },
      {
        "absent": false,
        "id": 3,
        "mainTask": "Putzen",
        "name": "Leo",
        "points": 0
      }
    ]
  };
  List<Map<String, dynamic>> testLog = [
    {
      "mainTask": "Bad-oben",
      "pointsGained": 6,
      "task": "Duschkabine",
      "time": "2021-09-14 21:09:58.900870",
      "userID": 3,
      "userName": "Leo"
    },
    {
      "mainTask": "Böden",
      "pointsGained": 10,
      "task": "Saugen und Wischen",
      "time": "2021-09-14 21:10:17.658426",
      "userID": 3,
      "userName": "Leo"
    }
  ];

  Future getData() async {
    var data = await ServerQueries.fetchData();
    return data;
  }

  Future getLogs() {
    var logs = new List.from(testLog);
    Map<int, List<Map>> weekList = {};
    logs.forEach((element) {
      var time = DateTime.parse(element['time'] ?? '');
      element['time'] = {
        'weekday': time.weekday - 1,
        'hour': time.hour,
        'minute': time.minute
      };
      int weekday = element['time']['weekday'];
      if (weekList[weekday] == null) {
        weekList[weekday] = [];
      }
      weekList[weekday]?.add(element);
    });
    return Future.delayed(const Duration(seconds: 2), () => weekList);
  }

  Future update(int taskID) {
    return ServerQueries.update(taskID);
  }

  Future authenticate() async {
    final prefs = await SharedPreferences.getInstance();
    final authKey = prefs.getString('authKey') ?? '0';
    if (authKey != '0') {
      final result = await ServerQueries.authenticate(authKey);
      if (!result['failed']) {
        ServerQueries.authKey = authKey;
        return true;
      }
    }
    return false;
  }

  Future evaluateAccessData(username, password) async {
    var replyJson = await ServerQueries.logIn(username, password);
    if (!replyJson['failed'] ?? true) {
      var authKey = replyJson['authKey'] ?? '0';
      final prefs = await SharedPreferences.getInstance();
      ServerQueries.authKey = authKey;
      prefs.setString('authKey', authKey);
    }
    if (replyJson['failed'] ?? true) {}
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    ServerQueries.authKey = '0';
    return true;
  }
}
