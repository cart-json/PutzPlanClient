import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final void Function() function;
  final String text;

  const ConfirmationDialog(
      {required Key key, required this.function, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(text),
      actions: [
        TextButton(
            onPressed: () {
              function();
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
}
