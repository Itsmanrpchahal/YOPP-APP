import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/firebase_profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/activity_suggestion_form.dart';

import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_sugession_service.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_sugession_bloc.dart';

import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';

class ActivitySuggestionScreen extends StatelessWidget {
  static get route {
    return FadeRoute(builder: (context) {
      return BlocProvider<ActivitySugessionBloc>(
        create: (BuildContext context) => ActivitySugessionBloc(
            FirebaseActivitySugessionService(), FirebaseProfileService()),
        child: ActivitySuggestionScreen(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
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
    return TransparentAppBar(
      context: context,
      titleText: "",
    );
  }

  _buildLoginIcon(BuildContext context) {
    final radius = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) /
        10;
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: Icon(
        CupertinoIcons.add,
      ),
    );
  }
}
