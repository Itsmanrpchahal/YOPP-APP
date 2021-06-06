import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    Key key,
    @required this.onPressed,
    this.icon,
    this.radius = 22,
    this.backgrounColor,
  }) : super(key: key);

  final double radius;
  final Function onPressed;
  final Widget icon;
  final Color backgrounColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: radius * 2,
        width: radius * 2,
        child: icon ??
            Icon(
              Icons.check,
              color: AppColors.orange,
              size: radius,
            ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgrounColor ?? Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 8)
            ]),
      ),
    );
  }
}
