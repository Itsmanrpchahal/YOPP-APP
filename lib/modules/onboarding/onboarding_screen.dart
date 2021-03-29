import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_gradients.dart';

import 'onboarding_app_bar.dart';

class OnBoardingScreen extends StatelessWidget {
  final String assetName;
  final String title;
  final List<String> descriptions;
  final Function onNext;

  const OnBoardingScreen({
    Key key,
    @required this.assetName,
    @required this.title,
    @required this.descriptions,
    @required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: onboardingAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final length = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final horizontalPadding = length / 8;
    final verticalPadding =
        (MediaQuery.of(context).size.height - (0.788 * length)) / 40;

    return Align(
      alignment: Alignment.topCenter,
      child: ListView(
        children: [
          SizedBox(height: verticalPadding),
          Image.asset(
            assetName,
            fit: BoxFit.scaleDown,
            width: length,
            height: (0.788 * length),
          ),
          SizedBox(height: verticalPadding * 2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: verticalPadding * 2),
          Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: descriptions
                    .map((e) => Text(
                          e,
                          textAlign: TextAlign.center,
                        ))
                    .toList(),
              )),
          Center(
            child: Container(
              height: 50,
              width: length * 0.6,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: AppGradients.verticalLinearGradient),
              child: FlatButton(
                  onPressed: onNext,
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
            ),
          ),
          SizedBox(height: 4 * verticalPadding),
        ],
      ),
    );
  }
}
