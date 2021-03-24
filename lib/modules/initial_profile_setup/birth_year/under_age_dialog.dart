import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class UnderAgeDialog {
  static void show(BuildContext context, {Function then}) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)), //this right here
            child: Container(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Be vigilant ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "18+ Disclaimer",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'If you are under 18, please make sure you have your parents permission to meet people and practise your sport. We take pride in keeping everyone safe.',
                    maxLines: 8,
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                  SizedBox(height: 64),
                  Builder(
                    builder: (context) => RaisedButton.icon(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        if (then != null) {
                          then();
                        }
                      },
                      icon: Icon(
                        Icons.check,
                        color: AppColors.orange,
                      ),
                      label: Container(
                        height: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
