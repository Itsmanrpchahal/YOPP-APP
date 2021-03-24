import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:yopp/helper/app_color/color_helper.dart';

import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/app_bar/transparent_appbar_with_cross.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';

class AboutScreen extends StatelessWidget {
  static Route get route {
    return FadeRoute(
      builder: (context) => AboutScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      extendBodyBehindAppBar: false,
      appBar: TransparentAppBarWithCrossAction(
        context: context,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: ClipPath(
        clipper: HalfCurveClipper(),
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Hexcolor("#F2F2F2")),
            padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Text(
                  "About",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 36),
                ),
                SizedBox(height: 20),
                Text(
                  "This app connects you with a local practise partner in the sport or activity that you need someone to do, practise or improve in. 💃🏸" +
                      "\n\nIt is an app for everyone and anyone\n",
                  style: TextStyle(color: Hexcolor("#222222"), fontSize: 12),
                ),
                Text(
                  "Do you need a dance partner 💃 to practise with, but can’t find one?" +
                      "\n\nDo you feel like playing tennis :tennis:, but no one you know is free?" +
                      "\n\nDo you want to go hiking, but not comfortable to do it alone?" +
                      "\n\nAre you looking for a game of chess ♜, but can’t find anyone who wants to play?" +
                      "\n\nTired of practising music :guitar:on your own and want another to jam with?",
                  style: TextStyle(
                      color: Hexcolor("#222222"),
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
                Text(
                  "\nIf you’re looking for someone to do an activity with, then YOPP is the app for you! Never let the lack of a practise partner stop you from doing what you love!" +
                      "\n\nThis app does not care where you are from, how old you are, your religion, gender or relationship status. Simply find your local activity practise partner and connect with similar like-minded people!",
                  style: TextStyle(color: Hexcolor("#222222"), fontSize: 12),
                ),
                Text(
                  "\nStep 1.",
                  style: TextStyle(
                      color: Hexcolor("#222222"),
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
                Text(
                  "Create your profile and select your activity.",
                  style: TextStyle(color: Hexcolor("#222222"), fontSize: 12),
                ),
                Text(
                  "\nStep 2.",
                  style: TextStyle(
                      color: Hexcolor("#222222"),
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
                Text(
                  "Match and chat to your new practise partner.",
                  style: TextStyle(color: Hexcolor("#222222"), fontSize: 12),
                ),
                Text(
                  "\nStep 3.",
                  style: TextStyle(
                      color: Hexcolor("#222222"),
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
                Text(
                  "Take charge of your joy, meet new friends and communities, make your day great!" +
                      "\n\nFind your perfect practise partner today!",
                  style: TextStyle(color: Hexcolor("#222222"), fontSize: 12),
                ),
              ],
            )),
      ),
    );
  }
}
