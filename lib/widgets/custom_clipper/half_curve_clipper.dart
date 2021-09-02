import 'package:flutter/material.dart';

class HalfCurveClipper extends CustomClipper<Path> {
  final double customRadius;

  HalfCurveClipper({this.customRadius});

  @override
  Path getClip(Size size) {
    double radius = customRadius ?? 60;
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius),
          radius: Radius.circular(radius), clockwise: true)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(HalfCurveClipper oldClipper) => false;
}
