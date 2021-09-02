import 'package:flutter/material.dart';

class TransparentAppBar extends AppBar {
  final BuildContext context;
  final String titleText;
  final Widget trailingAction;
  final bool showBackButton;

  TransparentAppBar({
    this.context,
    this.titleText,
    this.trailingAction,
    this.showBackButton = true,
  });
  @override
  Color get backgroundColor => Colors.transparent;

  @override
  bool get centerTitle => true;

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
  Widget get leading => showBackButton
      ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          })
      : Container();

  @override
  Widget get title => Text(titleText ?? "");
}
