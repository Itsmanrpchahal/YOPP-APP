import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_gradients.dart';
import 'package:yopp/widgets/app_bar/white_background_appBar_with_trailing.dart';
import 'package:yopp/widgets/app_bar/white_background_appbar.dart';
import 'package:yopp/widgets/custom_clipper/curve_clipper.dart';
import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

enum GradientType { topBottomLeft_bottomTopRight_curve, bottomTopRight_curve }

class HalfGradientScaffold extends StatelessWidget {
  final Widget firstHalf;
  final Widget firstHalfBackground;
  final Widget secondHalf;
  final String titleText;
  final bool hideActionButton;
  final bool showBackButton;
  final Function onActionPressed;
  final double ratio;
  final GradientType gradientType;

  final cornerRadius = 60.0;

  const HalfGradientScaffold({
    Key key,
    @required this.firstHalf,
    @required this.secondHalf,
    this.titleText,
    this.onActionPressed,
    this.hideActionButton = false,
    this.ratio = 0.5,
    this.gradientType = GradientType.topBottomLeft_bottomTopRight_curve,
    this.firstHalfBackground,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = _buildAppBar(context);
    final bodyHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return ProgressHud(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor:
            firstHalfBackground == null ? Colors.white : Colors.white,
        appBar: appBar,
        body: _buildBody(context, bodyHeight),
        // body: ProgressHud(
        //     child:
        //         Builder(builder: (context) => _buildBody(context, bodyHeight))),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double height) {
    final heightRatio = (ratio > 1 || ratio < 0) ? 0.5 : ratio;

    double offset = 0;
    switch (gradientType) {
      case GradientType.topBottomLeft_bottomTopRight_curve:
        offset = cornerRadius;
        break;

      case GradientType.bottomTopRight_curve:
        offset = 0;
        break;
    }
    final firstHalfHeight = (height * heightRatio) - offset;
    final secondHalfHeight = height - firstHalfHeight;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.none,
            height: firstHalfHeight + cornerRadius,
            child: firstHalfBackground ?? Container(),
          ),
          Column(
            children: [
              _buildFirstHalf(
                context,
                firstHalfHeight,
              ),
              _buildSecondHalf(
                context,
                secondHalfHeight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFirstHalf(BuildContext context, double height) {
    return Container(
      height: height,
      color: Colors.transparent,
      child: firstHalf,
    );
  }

  Widget _buildSecondHalf(BuildContext context, double height) {
    CustomClipper clipper;
    switch (gradientType) {
      case GradientType.topBottomLeft_bottomTopRight_curve:
        clipper = CurveClipper();
        break;
      case GradientType.bottomTopRight_curve:
        clipper = HalfCurveClipper();
        break;
    }
    return ClipPath(
        clipper: clipper,
        child: Container(
          decoration:
              BoxDecoration(gradient: AppGradients.halfBackgroundGradient),
          child: Column(
            children: [
              Container(
                height: cornerRadius,
              ),
              Transform.translate(
                offset: Offset(
                    0,
                    gradientType ==
                            GradientType.topBottomLeft_bottomTopRight_curve
                        ? 0
                        : -cornerRadius),
                child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: height),
                    child: secondHalf),
              )
            ],
          ),
        ));
  }

  Widget _buildAppBar(BuildContext context) {
    return hideActionButton
        ? WhiteBackgroundAppBar(
            context: context,
            titleText: titleText ?? "",
            showBackButton: showBackButton,
          )
        : WhiteBackgroundAppBarWithAction(
            context: context,
            titleText: titleText ?? "",
            onPressed: onActionPressed,
            showBackButton: showBackButton,
          );
  }
}
