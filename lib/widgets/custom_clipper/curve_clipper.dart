import 'package:flutter/material.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 60;
    Path path = Path()
      ..moveTo(0, 0)
      ..arcToPoint(Offset(radius, radius),
          radius: Radius.circular(radius), clockwise: false)
      ..lineTo(size.width - radius, radius)
      ..arcToPoint(Offset(size.width, radius + radius),
          radius: Radius.circular(radius), clockwise: true)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CurveClipper oldClipper) => false;
}
