import 'package:flutter/material.dart';

class SentMessageWidget extends StatelessWidget {
  final String message;

  const SentMessageWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width * 0.7;
    return Row(
      children: [
        Spacer(),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 80, maxWidth: maxWidth),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 6))
                ]),
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
