import 'package:flutter/material.dart';

class CustomSnackbar {
  static showProgress(BuildContext context, String text) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(text),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
  }

  static showFailed(BuildContext context, String text) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: Text(text)),
                Icon(Icons.error),
              ],
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
  }

  static showSuccess(BuildContext context, {String text, Duration duration}) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration ?? Duration(milliseconds: 500),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: Text(text ?? "Success")),
                Icon(Icons.check_circle_outline),
              ],
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
  }
}
