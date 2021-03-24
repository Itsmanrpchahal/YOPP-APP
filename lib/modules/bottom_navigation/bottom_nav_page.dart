import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_gradients.dart';
import 'package:yopp/helper/app_color/color_helper.dart';

class BottomNavPage extends StatelessWidget {
  final bool enableGradient;
  final Widget child;

  const BottomNavPage({
    Key key,
    this.enableGradient = false,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        enableGradient
            ? Container(
                height: double.infinity,
                width: double.infinity,
                decoration:
                    BoxDecoration(gradient: AppGradients.backgroundGradient),
              )
            : Container(
                color: Hexcolor("#F4F2F2"),
              ),
        Column(
          children: [
            Expanded(
              child: child,
            ),
            Container(
              height: 100,
            )
          ],
        )
      ],
    );
  }
}
