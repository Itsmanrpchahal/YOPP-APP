import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class MenuAppBar extends AppBar {
  final BuildContext context;
  final String titleText;

  MenuAppBar({
    @required this.context,
    @required this.titleText,
  });
  @override
  Color get backgroundColor => AppColors.green;

  @override
  bool get centerTitle => true;

  @override
  @override
  double get elevation => 0;

  @override
  Widget get leading => FlatButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        child: Image.asset(
          "assets/icons/menu.png",
          fit: BoxFit.scaleDown,
          width: 18,
          height: 18,
        ),
      );

  @override
  Widget get title => Text(
        titleText?.toUpperCase() ?? "",
        style: TextStyle(color: Colors.white),
      );
}

class DefaultAppBar extends AppBar {
  final BuildContext context;
  final String titleText;

  DefaultAppBar({
    @required this.context,
    @required this.titleText,
  });
  @override
  Color get backgroundColor => AppColors.green;

  @override
  bool get centerTitle => true;

  @override
  @override
  double get elevation => 0;

  @override
  Widget get leading => Navigator.of(context).canPop()
      ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          })
      : Container();

  @override
  Widget get title => Text(
        titleText?.toUpperCase() ?? "",
        style: TextStyle(color: Colors.white),
      );
}
