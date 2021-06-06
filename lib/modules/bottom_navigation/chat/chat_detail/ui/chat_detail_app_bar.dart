import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:yopp/helper/app_color/app_colors.dart';

class ChatDetailAppBar extends AppBar {
  final BuildContext context;
  final Color color;
  final String titleText;

  final Function onTrailingTap;

  final Function onBlockUser;
  final Function onReportUser;

  static const _reportUser = "Report User";
  static const _blockUser = "Block User";

  ChatDetailAppBar({
    @required this.context,
    this.color,
    this.titleText,
    this.onTrailingTap,
    @required this.onBlockUser,
    @required this.onReportUser,
  });
  @override
  Color get backgroundColor => AppColors.green;

  @override
  List<Widget> get actions => [
        Container(
          padding: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (String value) {
              if (value == _reportUser) {
                print("report");
                onReportUser();
              }
              if (value == _blockUser) {
                print("_blockUser");
                onBlockUser();
              }
            },
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: _reportUser,
                child: Text(
                  _reportUser,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const PopupMenuItem<String>(
                value: _blockUser,
                child: Text(
                  _blockUser,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ];

  @override
  double get elevation => 0;
  @override
  bool get centerTitle => true;

  @override
  Widget get leading => IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      );

  @override
  Widget get title => Text(
        titleText?.toUpperCase() ?? "",
        style: TextStyle(color: Colors.white),
      );
}

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
