import 'package:flutter/material.dart';

class ListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function goAbsent;
  final Function logout;
  final Function showLogs;
  final int points;
  final bool absent;
  final String title;

  ListAppBar(this.goAbsent, this.logout, this.showLogs, this.points,
      this.absent, this.title);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        backgroundColor: absent ? Colors.red : Colors.blue,
        actions: <Widget>[
          //Text(currentUser.points.toString()),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(absent ? 'go present' : 'go absent'),
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
                logout();
              } else if (result == 0) {
                goAbsent();
              } else if (result == 2) {
                showLogs();
              }
            },
          )
        ]);
  }
}
