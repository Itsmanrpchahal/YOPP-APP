import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class WelcomeDialog {
  static show(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Material(
              child: Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                alignment: Alignment.center,
                height: 400,
                color: AppColors.lightGreen,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    Image.asset(
                      'assets/icons/welcome_check.png',
                      height: 100,
                      width: 100,
                    ),
                    Spacer(),
                    Text(
                      "WELCOME TO YOPP",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Spacer(),
                    Text(
                      "Start By, Completing Your Profile, \nThen Add The Sports You Play.",
                      style: TextStyle(
                          color: Colors.white, fontSize: 14, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Here.",
                      style: TextStyle(
                          color: Colors.white, fontSize: 14, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    Transform.translate(
                      offset: Offset(30, -10),
                      child: Image.asset(
                        'assets/icons/welcome_arrow.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.only(left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );
  }
}
