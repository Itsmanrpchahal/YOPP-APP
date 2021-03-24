import 'package:flutter/material.dart';
import 'package:yopp/widgets/buttons/gradient_check_button.dart';

class WhiteBackgroundAppBarWithAction extends AppBar {
  final BuildContext context;
  final String titleText;
  final Function onPressed;
  final bool showBackButton;

  WhiteBackgroundAppBarWithAction({
    @required this.context,
    this.titleText,
    this.onPressed,
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
            child: GradientCheckButton(onPressed: onPressed)),
      ];

  @override
  double get elevation => 0;

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
