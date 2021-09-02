import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class TransparentAppBarWithAction extends AppBar {
  final BuildContext context;
  final String titleText;
  final Function onPressed;
  final bool showBackButton;

  TransparentAppBarWithAction({
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
          child: Transform.scale(
            scale: 1.5,
            child: IconButton(
              icon: Container(
                height: 30,
                width: 30,
                child: Icon(
                  Icons.check,
                  color: AppColors.orange,
                  size: 14,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, spreadRadius: 1, blurRadius: 8)
                    ]),
              ),
              onPressed: onPressed,
              color: Colors.transparent,
            ),
          ),
        ),
      ];

  @override
  double get elevation => 0;

  @override
  Widget get leading => showBackButton
      ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          })
      : Container();

  @override
  Widget get title => Text(
        titleText ?? "",
        style: TextStyle(color: Colors.white),
      );
}
