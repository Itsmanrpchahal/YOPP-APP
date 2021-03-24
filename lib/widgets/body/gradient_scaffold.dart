import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_gradients.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/widgets/app_bar/white_background_appBar_with_trailing.dart';
import 'package:yopp/widgets/app_bar/white_background_appbar.dart';

import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';

class ProfileScaffold extends StatelessWidget {
  final Widget firstHalf;
  final Widget firstHalfBackground;
  final Widget secondHalf;
  final String titleText;
  final bool hideActionButton;
  final AppBar appBar;
  final Function onActionPressed;
  final double ratio;

  final cornerRadius = 60.0;

  const ProfileScaffold({
    Key key,
    @required this.firstHalf,
    @required this.secondHalf,
    this.titleText,
    this.onActionPressed,
    this.hideActionButton = false,
    this.ratio = 0.5,
    this.firstHalfBackground,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Hexcolor("#F4F2F2"),
      appBar: appBar ?? _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    final heightRatio = (ratio > 1 || ratio < 0) ? 0.5 : ratio;

    final height = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;

    double offset = 0;

    final firstHalfHeight = (height * heightRatio) + appBarHeight + offset;
    final secondHalfHeight = height - firstHalfHeight;

    return Container(
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildFirstHalf(
            context,
            firstHalfHeight,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildSecondHalf(
              context,
              secondHalfHeight + cornerRadius,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstHalf(BuildContext context, double height) {
    return Stack(
      children: [
        Container(
          height: height,
          child: firstHalfBackground ?? Container(),
        ),
        Container(
          padding: EdgeInsets.only(top: 80, bottom: cornerRadius),
          height: height,
          child: firstHalf,
        )
      ],
    );
  }

  Widget _buildSecondHalf(BuildContext context, double height) {
    return ClipPath(
      clipper: HalfCurveClipper(),
      child: Container(
          padding: EdgeInsets.only(top: 0),
          decoration:
              BoxDecoration(gradient: AppGradients.halfBackgroundGradient),
          height: height,
          child: secondHalf),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return hideActionButton
        ? WhiteBackgroundAppBar(
            context: context,
            titleText: titleText ?? "",
          )
        : WhiteBackgroundAppBarWithAction(
            context: context,
            titleText: titleText ?? "",
            onPressed: onActionPressed,
          );
  }
}
