import 'package:flutter/material.dart';

import 'package:yopp/modules/bottom_navigation/filter/height_filter.dart';

class HeightRequiredDialog {
  static Future show(
    BuildContext context,
  ) async {
    var horizontalMargin = MediaQuery.of(context).size.height * 0.1;

    await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Container(
          margin: EdgeInsets.only(
              left: 32,
              right: 32,
              top: horizontalMargin,
              bottom: horizontalMargin),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: Colors.white),
          child: Material(
              color: Colors.white,
              child: StatefulBuilder(builder: (context, setState) {
                return HeightFilter();
              })),
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
