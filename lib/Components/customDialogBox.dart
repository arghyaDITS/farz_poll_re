import 'package:flutter/material.dart';

customDialog(context, String text, Function function) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text("Message"),
      content: Text(text),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            function();
          },
          child: Text("okay"),
        ),
      ],
    ),
  );
}
