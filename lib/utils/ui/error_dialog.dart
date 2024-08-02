import 'package:flutter/material.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String content,
}) {
  return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
            title: const Text('ERROR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            content: Text(content, style: const TextStyle(color: Colors.black54)),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners for the dialog
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          ));
}
