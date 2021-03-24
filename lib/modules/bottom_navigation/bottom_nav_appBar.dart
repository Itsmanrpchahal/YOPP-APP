import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/screens.dart';

class BottomNavAppBar extends AppBar {
  final BuildContext context;
  final Color color;
  final Text title;
  final Function backFromActivityScreen;

  BottomNavAppBar({
    this.context,
    this.backFromActivityScreen,
    this.color = Colors.transparent,
    this.title,
  });

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  bool get centerTitle => true;

  @override
  List<Widget> get actions => [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleIconButton(
            radius: 22,
            onPressed: () => _showActivityScreen(context),
            icon: SvgPicture.asset(
              "assets/icons/notification.svg",
              color: AppColors.orange,
              fit: BoxFit.none,
            ),
          ),
        ),
      ];

  @override
  double get elevation => 0;

  @override
  Widget get leading => Container(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(16, 0),
          child: CircleIconButton(
            radius: 22,
            onPressed: () => _showSettingScreen(context),
            icon: SvgPicture.asset(
              "assets/icons/settings.svg",
              color: AppColors.orange,
              fit: BoxFit.none,
            ),
          ),
        ),
      );

  _showSettingScreen(BuildContext context) async {
    await Navigator.of(context).pushNamed(SettingsScreen.routeName);
  }

  _showActivityScreen(BuildContext context) async {
    await Navigator.of(context).pushNamed(ActivityScreen.routeName);
    if (backFromActivityScreen != null) {
      backFromActivityScreen();
    }
  }
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
