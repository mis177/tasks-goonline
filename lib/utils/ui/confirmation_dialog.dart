import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'No',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              'Yes',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      );
    },
  );
}
