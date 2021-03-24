import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class AuthRoundedButton extends StatelessWidget {
  final Function() onPressed;

  const AuthRoundedButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      color: Colors.white,
      height: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onPressed: () => onPressed(),
      icon: Icon(
        Icons.check,
        color: AppColors.orange,
      ),
      label: Container(),
    );
  }
}
