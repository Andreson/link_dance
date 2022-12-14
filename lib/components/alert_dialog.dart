import 'package:flutter/material.dart';

class CustomAlertComponent extends StatelessWidget {
  final String title;
  final String content;
  VoidCallback? onPressed;

  CustomAlertComponent(
      {required this.title, required this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onPressed ?? (){Navigator.of(context).pop();},
          child: const Text("OK"),
        )
      ],
    );
  }
}
