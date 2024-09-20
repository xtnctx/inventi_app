import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String content;
  const ErrorDialog({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Error',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
    ;
  }
}
