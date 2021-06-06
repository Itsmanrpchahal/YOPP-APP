import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class VersionText extends StatelessWidget {
  final Color color;

  const VersionText({
    Key key,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Version 1.1.1",
        style: TextStyle(color: color ?? AppColors.lightGrey, fontSize: 12),
      ),
    );
  }
}
