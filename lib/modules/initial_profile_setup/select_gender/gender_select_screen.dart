import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender_event.dart';
import 'package:yopp/modules/screens.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';

import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import 'bloc/gender.dart';
import 'bloc/gender_bloc.dart';

class GenderSelectScreen extends StatefulWidget {
  static const routeName = '/select_gender';
  @override
  _GenderSelectScreenState createState() => _GenderSelectScreenState();
}

class _GenderSelectScreenState extends State<GenderSelectScreen> {
  Gender _gender;
  final cornerRadius = 60.0;

  selectGender(Gender gender) {
    setState(() {
      _gender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      appBar: _buildAppBar(context),
      body: ProgressHud(
        child: BlocListener<GenderBloc, BaseState>(
          child: _buildBody(context),
          listener: (context, state) async {
            ProgressHud.of(context).dismiss();
            switch (state.status) {
              case ServiceStatus.initial:
                break;
              case ServiceStatus.loading:
                ProgressHud.of(context).showLoading(text: state.message);
                break;
              case ServiceStatus.success:
                _showEnableLocationScreen(context);
                break;
              case ServiceStatus.failure:
                await ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.error, state.message);
                break;
            }
          },
        ),
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return TransparentAppBar(
      context: context,
      showBackButton: Navigator.of(context).canPop(),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildFemaleSection(context)),
        Text("Select Your Gender",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            )),
        Expanded(child: _buildMaleSection(context)),
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
            color: isSelected ? AppColors.green : Colors.white24,
          ),
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
                        color: isSelected ? AppColors.green : Colors.white24,
                      ),
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
    BlocProvider.of<GenderBloc>(context, listen: false)
        .add(GenderSelectionEvent(gender));
  }

  Widget _buildFemaleSection(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        _saveGender(context, Gender.female);
      },
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(
                isSelected: _gender == Gender.female, iconName: "female"),
            SizedBox(height: 8),
            Text(
              "Female",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMaleSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _saveGender(context, Gender.male);
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(isSelected: _gender == Gender.male, iconName: "male"),
            SizedBox(height: 8),
            Text(
              "Male",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void _showEnableLocationScreen(BuildContext context) {
    Navigator.of(context).push(EnableLocationScreen.route());
  }
}
