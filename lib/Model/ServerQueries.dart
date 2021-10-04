import 'package:dio/dio.dart';

class ServerQueries {
  static String authKey = '0';

  static Future fetchData() async {
    var response = await Server.query("/data?authKey=$authKey");
    return response.data;
  }

  static Future fetchLogs() async {
    var response = await Server.query("/data/logs?authKey=$authKey");
    return response.data;
  }

  //dem Server wird mitgeteilt wer welche Aufgabe erledigt hat
  //der Server übernimmt die Information und nimmt ggf Änderungen vor
  //dann werden die Daten neu übertragen
  static Future<dynamic> update(int taskID) async {
    var response = await Server.query(
        "/update?UpdateType=TaskDone&TaskKey=$taskID&authKey=$authKey");
    var result = response.data as Map;
    return result;
  }

  static Future<dynamic> logIn(username, hashPW) async {
    var response =
        await Server.query("/login?username=$username&password=$hashPW");
    var result = response.data as List;
    return result.first;
  }

  static Future<dynamic> authenticate(String authenticationKey) async {
    var response =
        await Server.query('/authenticate?authKey=$authenticationKey');
    var result = response.data as List;
    return result.first;
  }

  static Future<dynamic> setAbsentByID(int userID, bool absent) {
    if (absent) {
      return Server.query(
          '/update?UpdateType=setPresent&userID=$userID&authKey=$authKey');
    } else {
      return Server.query(
          '/update?UpdateType=setAbsent&userID=$userID&authKey=$authKey');
    }
  }
}

class Server {
  static final String _baseURL = "http://192.168.0.99:8500";

  static Future<Response<dynamic>> query(query) async {
    final Dio dio = new Dio();
    dio.options.headers['Connection'] = 'keep-alive';
    dio.options.headers['Keep-Alive'] = 'timeout=5, max=1000';
    var response;
    try {
      response = await dio.get("$_baseURL$query");
    } on DioError catch (e) {
      print(e);
    }
    return response;
  }
}
