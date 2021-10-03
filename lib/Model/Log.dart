import 'package:flutter/cupertino.dart';

class Log {
  final String task;
  final String user;
  final String mainTask;
  final DateTime time;

  @override
  String toString() {
    return 'Log{task: $task, user: $user, mainTask: $mainTask, time: $time}';
  }

  Log.fromJson(Map<String, dynamic> logs)
      : this.task = logs['task'] ?? '',
        this.user = logs['userName'] ?? '',
        this.mainTask = logs['mainTask'] ?? '',
        this.time = DateTime.parse(logs['time'] ?? '');

  static List<Log> jsonToLogList(List<dynamic> response) {
    var list = response.map((e) => Log.fromJson(e)).toList();
    return list;
  }

  static Future<Map<int, List<Log>>> weekListFromResponse(logsResponse) async {
    Map<int, List<Log>> weekList = {};
    var logsJson = await logsResponse;
    List<Log> logList = Log.jsonToLogList(logsJson.data as List);
    logList.forEach((element) {
      var weekday = element.time.weekday - 1;
      if (weekList[weekday] == null) {
        weekList[weekday] = [];
      }
      weekList[weekday]?.add(element);
    });
    return weekList;
  }
}
