import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/api_service.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/activity_suggestion_form.dart';

import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_sugession_service.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_sugession_bloc.dart';

import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class ActivitySuggestionScreen extends StatelessWidget {
  static get route {
    return FadeRoute(builder: (context) {
      return BlocProvider<ActivitySugessionBloc>(
        create: (BuildContext context) => ActivitySugessionBloc(
            FirebaseActivitySugessionService(), APIProfileService()),
        child: ActivitySuggestionScreen(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildLoginIcon(context),
          SizedBox(height: 24),
          ActivitySuggestionForm(),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return new DefaultAppBar(context: context, titleText: "Request a Sport");
  }

  _buildLoginIcon(BuildContext context) {
    final radius = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) /
        10;
    return CircleAvatar(
      backgroundColor: AppColors.green,
      radius: radius,
      child: Icon(
        CupertinoIcons.add,
        color: Colors.white,
      ),
    );
  }
}
