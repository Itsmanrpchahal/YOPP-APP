import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_bloc.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_event.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_bloc.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_event.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_state.dart';

import 'package:yopp/widgets/app_bar/white_background_appBar_with_trailing.dart';

import 'package:yopp/widgets/progress_hud/progress_hud.dart';
import 'package:yopp/widgets/slider/age_range_slider.dart';

import 'package:yopp/widgets/slider/location_slider.dart';

class PreferenceSettingScreen extends StatefulWidget {
  static const routeName = "/preference";

  @override
  _PreferenceSettingScreenState createState() =>
      _PreferenceSettingScreenState();
}

class _PreferenceSettingScreenState extends State<PreferenceSettingScreen> {
  RangeValues ageRange = RangeValues(
    PreferenceConstants.defaultStartAgeValue,
    PreferenceConstants.defaultEndAgeValue,
  );

  double locationRange = PreferenceConstants.defaultLocationRangeValue;

  @override
  void initState() {
    BlocProvider.of<PreferenceBloc>(context).add(GetPreferenceEvent());
    super.initState();
  }

  void updateData(PreferenceState state) {
    print("Range" + state.locationRange.toString());
    ageRange = state.ageRange;
    locationRange = state.locationRange;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
        backgroundColor: Hexcolor("#F2F2F2"),
        appBar: WhiteBackgroundAppBarWithAction(
          context: context,
          onPressed: () => updatePreference(context),
        ),
        body: BlocListener<PreferenceBloc, PreferenceState>(
          listener: (context, state) {
            ProgressHud.of(context).dismiss();
            print(state.serviceMessage);
            switch (state.serviceStatus) {
              case PreferenceStatus.none:
                break;
              case PreferenceStatus.loading:
                break;

              case PreferenceStatus.failure:
                ProgressHud.of(context).showAndDismiss(
                    ProgressHudType.error, state.serviceMessage);
                break;
              case PreferenceStatus.loaded:
                updateData(state);
                break;
              case PreferenceStatus.updating:
                break;
              case PreferenceStatus.updated:
                BlocProvider.of<DiscoverBloc>(context)
                    .add(DiscoverUsersEvent());
                Navigator.of(context).pop();
                break;
            }
          },
          child: _buildBody(context),
        ),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 30),
      child: ListView(
        children: [
          Text(
            "Select Preference",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 36),
          ),
          SizedBox(
            height: 30,
          ),
          AgeRangeSlider(
            ageRange: ageRange,
            onChanged: (value) {
              setState(() {
                ageRange = value;
              });
            },
          ),
          LocationSlider(
            range: locationRange,
            onChanged: (value) {
              setState(() {
                locationRange = value;
              });
            },
          ),
        ],
      ),
    );
  }

  void updatePreference(BuildContext context) {
    BlocProvider.of<PreferenceBloc>(context).add(UpdatePreferenceEvent(
      ageRange: ageRange,
      distance: locationRange,
    ));
  }
}
