import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class UpdateDialog {
  static show(BuildContext context, {String title, String subtitle}) {
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
            width: MediaQuery.of(context).size.width * 0.8,
            child: Material(
              child: Container(
                padding: EdgeInsets.only(left: 32, right: 32),
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
                      title ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Spacer(),
                    Text(
                      subtitle ?? "",
                      style: TextStyle(
                          color: Colors.white, fontSize: 14, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    OutlineButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "OK",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
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
