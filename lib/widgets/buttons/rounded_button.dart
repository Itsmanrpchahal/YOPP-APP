import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function() onPressed;
  final String titleText;
  final TextStyle titleStyle;
  final Color backgroundColor;

  const RoundedButton({
    Key key,
    @required this.onPressed,
    this.titleText,
    this.titleStyle = const TextStyle(),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        color: backgroundColor,
        height: 50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: onPressed,
        child: Text(
          titleText ?? "",
          style: titleStyle,
        ));
  }
}

class RaisedRoundedButton extends StatelessWidget {
  final Function() onPressed;
  final String titleText;
  final TextStyle titleStyle;
  final Color backgroundColor;

  const RaisedRoundedButton({
    Key key,
    @required this.onPressed,
    this.titleText,
    this.titleStyle = const TextStyle(),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: onPressed,
        child: Text(
          titleText ?? "",
          style: titleStyle,
        ));
  }
}
