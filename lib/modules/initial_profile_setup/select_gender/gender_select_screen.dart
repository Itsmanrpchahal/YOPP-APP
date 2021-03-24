import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:yopp/helper/app_color/app_gradients.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender_event.dart';
import 'package:yopp/modules/screens.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar_with_action.dart';
import 'package:yopp/widgets/app_bar/white_background_appBar_with_trailing.dart';

import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/custom_clipper/curve_clipper.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import 'bloc/gender.dart';
import 'bloc/gender_bloc.dart';

class GenderSelectScreen extends StatefulWidget {
  static const routeName = '/select_gender';
  @override
  _GenderSelectScreenState createState() => _GenderSelectScreenState();
}

class _GenderSelectScreenState extends State<GenderSelectScreen> {
  Gender _gender = Gender.female;
  final cornerRadius = 60.0;

  selectGender(Gender gender) {
    setState(() {
      _gender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      hideGradient: _gender == Gender.female,
      appBar: _buildAppBar(context),
      body: ProgressHud(
        child: BlocListener<GenderBloc, BaseState>(
          child: _buildBody(context),
          listener: (context, state) {
            switch (state.status) {
              case ServiceStatus.initial:
                break;
              case ServiceStatus.loading:
                ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.loading, state.message);
                break;
              case ServiceStatus.success:
                _showEnableLocationScreen(context);
                break;
              case ServiceStatus.failure:
                ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.error, state.message);
                break;
            }
          },
        ),
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return _gender == Gender.female
        ? WhiteBackgroundAppBarWithAction(
            context: context,
            titleText: "You Are",
            onPressed: () => _saveGender(context, Gender.female),
            showBackButton: Navigator.of(context).canPop(),
          )
        : TransparentAppBarWithAction(
            context: context,
            titleText: "You Are",
            onPressed: () => _saveGender(context, Gender.male),
            showBackButton: Navigator.of(context).canPop(),
          );
  }

  _buildBody(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        _buildFemaleSection(context, height / 2 - cornerRadius),
        _buildMaleSection(context, height / 2 + cornerRadius),
      ],
    );
  }

  Widget _buildIcon({bool isSelected, String iconName}) {
    final size = MediaQuery.of(context).size;
    final minLength = min(size.width, size.height);

    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white : Colors.white24,
              gradient: isSelected ? AppGradients.backgroundGradient : null),
          height: minLength / 3.5,
          width: minLength / 3.5,
          child: SvgPicture.asset(
            'assets/icons/$iconName.svg',
            fit: BoxFit.none,
            height: minLength / 7,
            width: minLength / 7,
          ),
        ),
        isSelected
            ? Positioned(
                bottom: -8,
                right: -8,
                child: CircleAvatar(
                  radius: minLength / 14,
                  backgroundColor: Colors.white,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.white : Colors.white24,
                          gradient: isSelected
                              ? AppGradients.backgroundGradient
                              : null),
                      height: (minLength / 7) - 16,
                      width: (minLength / 7) - 16,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: minLength / 24,
                      )),
                ),
              )
            : Container()
      ],
    );
  }

  _saveGender(BuildContext context, Gender gender) {
    BlocProvider.of<GenderBloc>(context).add(GenderSelectionEvent(gender));
  }

  Widget _buildFemaleSection(BuildContext context, double height) {
    return InkWell(
      onTap: () {
        selectGender(Gender.female);
      },
      child: Container(
        height: height,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: _gender == Gender.female ? Colors.white : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(
                isSelected: _gender == Gender.female, iconName: "female"),
            SizedBox(height: 8),
            Text(
              "Female",
              style: Theme.of(context).textTheme.headline5.copyWith(
                  color:
                      _gender == Gender.female ? Colors.black : Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMaleSection(BuildContext context, double height) {
    return ClipPath(
      clipper: CurveClipper(),
      child: GestureDetector(
        onTap: () {
          selectGender(Gender.male);
        },
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: _gender == Gender.male
                ? null
                : AppGradients.halfBackgroundGradient,
            borderRadius: BorderRadius.only(topRight: Radius.circular(60)),
          ),
          child: Transform.translate(
            offset: Offset(0, 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(
                    isSelected: _gender == Gender.male, iconName: "male"),
                SizedBox(height: 8),
                Text(
                  "Male",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color:
                          _gender == Gender.male ? Colors.black : Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEnableLocationScreen(BuildContext context) {
    Navigator.of(context).push(EnableLocationScreen.route());
  }
}
