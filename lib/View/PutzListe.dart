/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:putzplan/Model/User.dart';
import 'LoadingScreen.dart';
import '../Model/SubTask.dart';
import '../Model/ServerQueries.dart';
import 'LogView.dart';

class PutzListeView extends StatefulWidget {
  PutzListeView({Key key, this.logout}) : super(key: key);

  final Function logout;

  @override
  _PutzListeViewState createState() => _PutzListeViewState();
}

class _PutzListeViewState extends State<PutzListeView> {
  String _name;
  List<SubTask> subTasks;
  List<User> users;
  List<User> lastWeek;
  User currentUser;
  String title;

  Future data;
  PageController _controller;

  initState() {
    super.initState();
    _controller = PageController(
      initialPage: 0,
    );
    refresh();
  }

  void _setTitle(int page) {
    setState(() {
      switch (page) {
        case 0:
          title = _name;
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

  Future<void> refresh() async {
    var data = await fetchData();
    reload(data.data as Map);
    setState(() {
      this.build(context);
    });
  }

  Future fetchLogs() {
    var logJson = ServerQueries.fetchLogs();
    return logJson;
  }

  Future fetchData() {
    data = ServerQueries.fetchData();
    return data;
  }

  reload(data) async {
    if (data['failed'] ?? false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return _authenticationFailedDialog();
          });
    } else {
      users = User.jsonToUserList(data['users'] as List);
      subTasks = SubTask.jsonToTaskList(data['tasks'][0]['subTasks'] as List);
      _name = data['tasks'][0]['name'];
      currentUser = User.fromJson(data['tasks'][0]['currentUser']);
      lastWeek = User.jsonToUserList(data['lastWeek'] as List);
      //this.build(context);
    }
  }

  void setAbsent(bool absent) {
    setAbsentById(currentUser.id, absent);
  }

  void setAbsentById(int userId, bool absent) async {
    await ServerQueries.setAbsentByID(userId, absent);
    refresh();
  }

  update(int taskId) async {
    var response = await ServerQueries.update(taskId);
    if ((response['failed'] ?? false) &&
        (response['message'] ?? ' ') != 'wrong authKey') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alreadyDoneDialog(
                response['user'] ?? '', response['task'] ?? '');
          });
    }
    refresh();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this.data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    title: Text(title == null ? _name : title),
                    backgroundColor:
                        currentUser.absent ? Colors.red : Colors.blue,
                    actions: <Widget>[
                      //Text(currentUser.points.toString()),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text(currentUser.absent
                                ? 'go present'
                                : 'go absent'),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text('ausloggen'),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text('show logs'),
                            value: 2,
                          ),
                        ],
                        onSelected: (result) {
                          if (result == 1) {
                            widget.logout();
                          } else if (result == 0) {
          setAbsent(currentUser.absent);
          }}
                      )
                    ]),
                body: PageView(
                  controller: _controller,
                  onPageChanged: _setTitle,
                  children: [
                    _buildTaskList(),
                    _buildUserList(),
                    _buildPastWeekOverView(),
                  ],
                ));
          } else {
            return LoadingScreen('loading data...');
          }
        });
  }

  Widget _buildUserList() {
    return RefreshIndicator(
      onRefresh: refresh,
      //ListViewBuilder erstellt einen Listeneintrag für alle Aufgaben
      child: ListView.builder(
          itemCount: users.length,
          padding: const EdgeInsets.all(2),
          itemBuilder: (BuildContext _context, int i) {
            return _buildUserRow(users[i]);
          }),
    );
  }

  //anklickbare Taskbar mit Informationen zur Aufgabe
  Widget _buildUserRow(User user) {
    return Card(
        child: ListTile(
      trailing: Text(
        user.points.toString(),
      ),
      title: Text(
        user.name,
        style: TextStyle(color: (user.absent ? Colors.red : Colors.green)),
      ),
      subtitle: Text(user.mainTaskName),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return _setPresenceDialog(user);
            });
      },
    ));
  }

  Widget _buildTaskList() {
    //RefreshIndicator zum Aktualisieren durch 'herunterziehen' der Liste
    if (subTasks.length == 0) {
      return Center(
          child: Text(
              'Für heute ist alles erledigt, schau morgen wieder vorbei',
              style: TextStyle(color: Colors.grey)));
    }
    return RefreshIndicator(
      onRefresh: refresh,
      //ListViewBuilder erstellt einen Listeneintrag für alle Aufgaben
      child: ListView.builder(
          itemCount: subTasks.length,
          padding: const EdgeInsets.all(2),
          itemBuilder: (BuildContext _context, int i) {
            return _buildTaskRow(subTasks[i]);
          }),
    );
  }

  //anklickbare Taskbar mit Informationen zur Aufgabe
  Widget _buildTaskRow(SubTask task) {
    return Card(
        child: ListTile(
      trailing: Text(
        task.points.toString(),
      ),
      title: Text(
        task.name,
        style: TextStyle(
            color: (task.mainTaskName == _name ? Colors.black : Colors.blue)),
      ),
      subtitle: Text(task.mainTaskName),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return taskDialogue(task);
            });
      },
    ));
  }

  Widget _buildPastWeekOverView() {
    if (lastWeek.length == 0) {
      return Center(
        child: Text('no historical data found'),
      );
    }
    return RefreshIndicator(
      onRefresh: refresh,
      //ListViewBuilder erstellt einen Listeneintrag für alle Aufgaben
      child: ListView.builder(
          itemCount: lastWeek.length,
          padding: const EdgeInsets.all(2),
          itemBuilder: (BuildContext _context, int i) {
            return _buildLastWeekRow(context, lastWeek[i]);
          }),
    );
  }

  Widget _buildLastWeekRow(context, User user) {
    return Card(
        child: ListTile(
      trailing: Text(
        user.points.toString(),
      ),
      title: Text(
        user.name,
        style: TextStyle(color: (user.points >= 20 ? Colors.blue : Colors.red)),
      ),
      subtitle: Text(user.mainTaskName),
    ));
  }

  //Wird eine Aufgabe angeklickt kann man sie entweder
  //einfach so erledigen
  //für einen anderen erledigen
  //oder sie ist bereits erledigt
  Widget taskDialogue(SubTask task) {
    return AlertDialog(
      title: Text('Aufgabe "' + task.name + '" erledigt?'),
      actions: [
        TextButton(
            onPressed: () {
              update(task.id);
              Navigator.of(context).pop();
            },
            child: Text('Ja')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Nein')),
      ],
    );
  }

  Widget alreadyDoneDialog(String user, String task) {
    return AlertDialog(
      title: Text("$user hat die Aufgabe '$task' schon erledigt!"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"))
      ],
    );
  }

  Widget _setPresenceDialog(User user) {
    return AlertDialog(
      title: Text(user.name +
          " als " +
          (user.absent ? 'anwesend' : 'abwesend') +
          ' erklären?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Nein")),
        TextButton(
            onPressed: () {
              setAbsentById(user.id, user.absent);
              Navigator.of(context).pop();
            },
            child: Text("Ja")),
      ],
    );
  }

  Widget _authenticationFailedDialog() {
    return AlertDialog(
      title: Text('Etwas ist schief gelaufen, bitte melde Dich nochmal an!'),
      actions: [
        TextButton(
            onPressed: () {
              widget.logout();
              Navigator.of(context).pop();
            },
            child: Text("OK")),
      ],
    );
  }
}*/
