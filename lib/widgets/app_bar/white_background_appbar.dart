import 'package:flutter/material.dart';

class WhiteBackgroundAppBar extends AppBar {
  final BuildContext context;
  final String titleText;
  final Widget trailingAction;
  final bool showBackButton;

  WhiteBackgroundAppBar({
    this.context,
    this.titleText,
    this.trailingAction,
    this.showBackButton = true,
  });
  @override
  Color get backgroundColor => Colors.transparent;

  @override
  List<Widget> get actions => [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: trailingAction ?? Container(),
        ),
      ];

  @override
  double get elevation => 0;

  @override
  bool get centerTitle => true;

  @override
  Widget get leading => showBackButton
      ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          })
      : Container();

  @override
  Widget get title => Text(
        titleText ?? "",
        style: TextStyle(color: Colors.black),
      );
}
