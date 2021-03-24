import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/modules/screens.dart';

import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';

class SetupCompleteScreen extends StatelessWidget {
  static const String routeName = '/setup_complete';

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      appBar: TransparentAppBar(
        context: context,
        showBackButton: false,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final minLength = min(size.height, size.width);
    final paddingUnit = size.height / 30;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 40),
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(context, minLength / 4),
            SizedBox(height: 24),
            _buildTitleText(context),
            SizedBox(height: paddingUnit),
            _buildSubtitleText(context),
            SizedBox(height: paddingUnit),
            Container(color: AppColors.orange, height: 2, width: 26),
            SizedBox(height: 2 * paddingUnit),
            _buildDoneButton(context, minLength / 6),
            SizedBox(height: paddingUnit / 2),
            Text("Complete your profile",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.white)),
            SizedBox(height: 2 * paddingUnit),
            SizedBox(height: paddingUnit),
          ],
        )),
      ),
    );
  }

  _buildIcon(BuildContext context, double iconWidth) {
    return CircleAvatar(
      radius: iconWidth / 2,
      backgroundColor: Colors.white24,
      child: Icon(
        Icons.emoji_emotions,
        color: Colors.white,
        size: iconWidth / 2,
      ),
    );
  }

  _buildDoneButton(BuildContext context, double iconWidth) {
    return InkWell(
      onTap: () => _showEditProfileScreen(context),
      child: CircleAvatar(
        radius: iconWidth / 2,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.arrow_forward,
          size: iconWidth / 2,
          color: AppColors.orange,
        ),
      ),
    );
  }

  _buildTitleText(BuildContext context) {
    return Text(
      "All done!",
      textAlign: TextAlign.center,
      style:
          Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
    );
  }

  _buildSubtitleText(BuildContext context) {
    return Text(
        "It’s time to find your practise partners! Start swiping to match with people near you",
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Colors.white70));
  }

  _showEditProfileScreen(BuildContext context) {
    Navigator.of(context).push(EditProfileScreen.route(null, true));
  }
}
