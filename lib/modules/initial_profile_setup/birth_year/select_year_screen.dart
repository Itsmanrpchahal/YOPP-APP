import 'dart:math';

import 'package:flutter/material.dart';

import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/modules/initial_profile_setup/birth_year/birth_year_form.dart';

import 'package:yopp/widgets/body/full_gradient_scaffold.dart';

import 'package:yopp/widgets/app_bar/transparent_appbar.dart';

class SelectYearScreen extends StatelessWidget {
  static const String routeName = '/selectYear';

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
        appBar: TransparentAppBar(
          context: context,
          titleText: "What’s Your D.O.B",
          showBackButton: Navigator.of(context).canPop(),
        ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildIcon(context),
            SizedBox(height: 40),
            Text(
              "Birth Year",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
                "What year were you born, this helps match you with a practise partner..",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white70)),
            SizedBox(height: 12),
            Center(
                child:
                    Container(color: AppColors.orange, height: 2, width: 26)),
            SizedBox(height: 32),
            BirthYearFrom(),
          ],
        )),
      ),
    );
  }

  _buildIcon(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconWidth = min(size.height, size.width) / 4;
    return CircleAvatar(
      radius: iconWidth / 2,
      backgroundColor: Colors.white24,
      child: Icon(
        Icons.smartphone,
        color: Colors.white,
        size: iconWidth / 2,
      ),
    );
  }
}
