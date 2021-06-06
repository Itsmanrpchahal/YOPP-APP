import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/color_helper.dart';

class TimeMessageWidget extends StatelessWidget {
  final String message;

  const TimeMessageWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Hexcolor("#222222").withOpacity(0.25),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
