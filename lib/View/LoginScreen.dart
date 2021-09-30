import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'LoadingScreen.dart';

class LoginScreen extends StatelessWidget {
  final Function evaluateAccessData;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen(this.evaluateAccessData);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Putzplan'),
        ),
        body: authScaffold(context));
  }

  Widget authScaffold(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    var username = nameController.text;
                    var password =
                        sha256.convert(utf8.encode(passwordController.text));
                    evaluateAccessData(username, password);
                  },
                )),
          ],
        ));
  }

  loginError(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Benutzername oder Passwort sind falsch!"),
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
