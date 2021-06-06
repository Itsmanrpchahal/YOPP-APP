import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/ui/dot_indicator/dots_decorator.dart';
import 'package:yopp/modules/_common/ui/dot_indicator/dots_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  final String assetName;
  final String title;
  final List<String> descriptions;
  final Function onNext;
  final Function onSkip;
  final int index;

  const OnBoardingScreen({
    Key key,
    @required this.assetName,
    @required this.title,
    @required this.descriptions,
    @required this.onNext,
    @required this.onSkip,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final length = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final horizontalPadding = length / 8;
    final verticalPadding =
        (MediaQuery.of(context).size.height - (0.788 * length)) / 20;

    return Align(
      alignment: Alignment.topCenter,
      child: ListView(
        children: [
          SizedBox(height: verticalPadding),
          Row(
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
                child:
                    Text("YOPP", style: Theme.of(context).textTheme.headline6),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: verticalPadding),
          Image.asset(
            assetName,
            fit: BoxFit.scaleDown,
            width: length / 2,
            height: length / 2,
          ),
          SizedBox(height: verticalPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              title,
              style: TextStyle(color: AppColors.green, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: verticalPadding),
          Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: descriptions
                    .map((e) => Text(
                          e,
                          style:
                              TextStyle(color: AppColors.green, fontSize: 18),
                          textAlign: TextAlign.center,
                        ))
                    .toList(),
              )),
          SizedBox(height: verticalPadding),
          DotsIndicator(
            dotsCount: 3,
            position: index.toDouble(),
            decorator: DotsDecorator(
              activeColor: AppColors.green,
              color: Colors.white,
              size: Size.square(12),
              activeSize: Size.square(12),
            ),
          ),
          SizedBox(height: verticalPadding),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: FlatButton(
                onPressed: onNext,
                color: AppColors.green,
                child: Text("CONTINUE",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white))),
          ),
          SizedBox(height: verticalPadding),
          FlatButton(
              onPressed: onSkip,
              child: Text("SKIP THIS TOUR",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightGreen))),
        ],
      ),
    );
  }
}
