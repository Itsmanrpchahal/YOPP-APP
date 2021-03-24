import 'package:flutter/material.dart';

@override
onboardingAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Image.asset(
          'assets/icons/navigation_title_icon.png',
          height: 40,
          width: 40,
        ),
        Container(
          padding: EdgeInsets.all(0),
          child: Text("YOPP", style: Theme.of(context).textTheme.headline6),
        ),
        Spacer(),
      ],
    ),
  );
}
