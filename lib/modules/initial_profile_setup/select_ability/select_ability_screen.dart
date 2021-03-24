import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/_common/sports/data/requirements/cycling_requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/running-requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/swimming_requirements.dart';

import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/ability_list_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/ability_list_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';
import 'package:yopp/modules/initial_profile_setup/select_ability/bloc/ability_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/select_ability/bloc/ability_event.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/buttons/handicap_widget.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';
import 'package:yopp/widgets/slider/cycling_distance_slider.dart';
import 'package:yopp/widgets/slider/height_slider.dart';
import 'package:yopp/widgets/slider/running_distance_slider.dart';
import 'package:yopp/widgets/slider/swimming_distance_slider.dart';
import 'package:yopp/widgets/textfield/belt_textfield.dart';

import 'package:yopp/widgets/slider/pace_slider.dart';
import 'package:yopp/widgets/slider/skill_level_slider.dart';
import 'package:yopp/widgets/slider/weight_slider.dart';
import 'package:yopp/widgets/body/half_gradient_scaffold.dart';
import 'package:yopp/widgets/buttons/looking_for_widget.dart';

import '../../screens.dart';

enum SelectAbilityEnum { initialSetup, addAnother, edit, selectedEdit }

class SelectAbilityScreen extends StatefulWidget {
  static Route route({
    @required UserSport userSport,
    @required SelectAbilityEnum showtype,
  }) =>
      FadeRoute(
          builder: (_) => SelectAbilityScreen(
                showtype: showtype,
                userSport: userSport,
              ));

  final SelectAbilityEnum showtype;

  final UserSport userSport;

  const SelectAbilityScreen({
    Key key,
    @required this.showtype,
    @required this.userSport,
  }) : super(key: key);

  @override
  _SelectAbilityScreenState createState() => _SelectAbilityScreenState();
}

class _SelectAbilityScreenState extends State<SelectAbilityScreen> {
  List<SportRequirements> requirements = [];
  Gender _selectedGender;
  SkillLevel _skilllevel;
  RunningLevel _runningLevel;
  double _height;

  PaceLevel _pace;
  int _handicapLevel;
  TextEditingController _beltController;
  double _weight;
  UserSport userSport;
  String _imagePath;

  CyclingLevel _cyclingLevel;
  SwimmingLevel _swimmingLevel;

  @override
  void initState() {
    _selectedGender = widget?.userSport?.gender ?? Gender.any;
    userSport = UserSport(
      sportId: widget.userSport.sportId,
      name: widget.userSport.name,
      categoryId: widget.userSport.categoryId,
      styleId: widget.userSport.styleId,
      gender: _selectedGender,
    );
    print(_selectedGender?.name ?? "NO gender");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      initialProfileSetup();
    });

    super.initState();
  }

  initialProfileSetup() async {
    requirements = userSport.getRequirements();
    _imagePath = userSport.getImagepath();

    requirements.forEach((element) async {
      switch (element) {
        case SportRequirements.skill_level:
          _skilllevel = widget.userSport?.skillLevel ?? SkillLevel.beginner;
          break;

        case SportRequirements.cyclingDistance:
          _cyclingLevel = widget.userSport?.cyclingLevel ?? CyclingLevel.level0;
          break;
        case SportRequirements.runningDistance:
          _runningLevel = widget.userSport?.runningLevel ?? RunningLevel.level0;
          break;
        case SportRequirements.pace:
          _pace = widget.userSport?.pace ?? PaceLevel.slow;
          break;
        case SportRequirements.handicap:
          _handicapLevel = widget.userSport?.handicap ??
              PreferenceConstants.defaultHandicapLevel;
          break;
        case SportRequirements.belt:
          _beltController =
              TextEditingController(text: widget.userSport?.belt ?? "");
          break;

        case SportRequirements.height:
          final userProfile = await SharedPreferenceService().getUserProfile();

          _height =
              userProfile.height ?? PreferenceConstants.defaultHeightValue;

          break;
        case SportRequirements.weight:
          final userProfile = await SharedPreferenceService().getUserProfile();

          _weight = userProfile.weight ?? PreferenceConstants.defaultWeight;

          break;
        case SportRequirements.swimmingDistance:
          _swimmingLevel =
              widget.userSport?.swimmingLevel ?? SwimmingLevel.level0;
          break;
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    _beltController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: HalfGradientScaffold(
        onActionPressed: () => _saveActivity(context),
        firstHalf: _buildFirstHalf(context),
        secondHalf: Builder(
          builder: (context) => BlocListener<EditAbilityBloc, BaseState>(
            child: _buildSecondHalf(context),
            listener: (contex, state) {
              ProgressHud.of(context).dismiss();
              switch (state.status) {
                case ServiceStatus.initial:
                  break;
                case ServiceStatus.loading:
                  ProgressHud.of(context)
                      .show(ProgressHudType.loading, state.message);
                  break;
                case ServiceStatus.success:
                  if (widget.showtype == SelectAbilityEnum.initialSetup) {
                    Navigator.of(context)
                        .pushNamed(SetupCompleteScreen.routeName);
                  }

                  if (widget.showtype == SelectAbilityEnum.addAnother) {
                    BlocProvider.of<AbilityListBloc>(context)
                        .add(GetAbilityListEvent());
                    BlocProvider.of<ProfileBloc>(context).add(GetUserProfile());
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }

                  if (widget.showtype == SelectAbilityEnum.edit ||
                      widget.showtype == SelectAbilityEnum.selectedEdit) {
                    BlocProvider.of<AbilityListBloc>(context)
                        .add(GetAbilityListEvent());
                    BlocProvider.of<ProfileBloc>(context).add(GetUserProfile());

                    Navigator.of(context).pop();
                  }

                  break;
                case ServiceStatus.failure:
                  ProgressHud.of(context)
                      .showAndDismiss(ProgressHudType.error, state.message);
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFirstHalf(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _imagePath == null
              ? Container()
              : Expanded(
                  child: SvgPicture.asset(
                    _imagePath,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
          SizedBox(height: 16),
          requirements != null && requirements.isNotEmpty
              ? Text(
                  "Select Your Ability",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )
              : Container(),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                userSport?.name ?? "",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondHalf(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 16),
      child: Column(children: _getRequirementsWidgets(requirements)),
    );
  }

  List<Widget> _getRequirementsWidgets(List<SportRequirements> requirements) {
    List<Widget> widgets = [];

    widgets = requirements.map((requirement) {
      switch (requirement) {
        case SportRequirements.skill_level:
          userSport = userSport.copyWith(skillLevel: _skilllevel);
          return SkillLevelSlider(
            level: _skilllevel,
            showAll: false,
            onChange: (value) {
              _skilllevel = value;
              userSport = userSport.copyWith(skillLevel: _skilllevel);
            },
          );
          break;

        case SportRequirements.height:
          userSport = userSport.copyWith(heightRequired: true);
          return HeightSlider(
            height: _height,
            onChanged: (value) {
              _height = value;
            },
          );
          break;

        case SportRequirements.cyclingDistance:
          userSport = userSport.copyWith(cyclingLevel: _cyclingLevel);

          return CyclingDistanceSlider(
            level: _cyclingLevel,
            onChange: (value) {
              _cyclingLevel = value;
              userSport = userSport.copyWith(cyclingLevel: _cyclingLevel);
            },
          );
          break;

        case SportRequirements.runningDistance:
          userSport = userSport.copyWith(runningLevel: _runningLevel);
          return RunningDistanceSlider(
            level: _runningLevel,
            onChange: (value) {
              _runningLevel = value;

              userSport = userSport.copyWith(runningLevel: _runningLevel);
            },
          );
          break;

        case SportRequirements.pace:
          userSport = userSport.copyWith(pace: _pace);
          return PaceSlider(
            level: _pace,
            onChanged: (value) {
              _pace = value;
              userSport = userSport.copyWith(pace: _pace);
            },
          );
          break;

        case SportRequirements.handicap:
          userSport = userSport.copyWith(handicap: _handicapLevel);
          return HandicapWidget(
            handicapLevel: _handicapLevel,
            onChanged: (value) {
              setState(() {
                _handicapLevel = value;
                userSport = userSport.copyWith(handicap: _handicapLevel);
              });
            },
          );
          break;

        case SportRequirements.belt:
          userSport = userSport.copyWith(belt: _beltController.text);
          return BeltField(
            controller: _beltController,
            onChanged: (value) {
              userSport = userSport.copyWith(belt: _beltController.text);
            },
            placeHolderText: "Enter your Belt",
          );
          break;

        case SportRequirements.weight:
          userSport = userSport.copyWith(weightRequired: true);

          return WeightSlider(
            weight: _weight,
            onChanged: (value) {
              _weight = value;
            },
          );
          break;
        case SportRequirements.swimmingDistance:
          userSport = userSport.copyWith(swimmingLevel: _swimmingLevel);

          return SwimmingDistanceSlider(
            level: _swimmingLevel,
            onChange: (value) {
              _swimmingLevel = value;
              userSport = userSport.copyWith(swimmingLevel: _swimmingLevel);
            },
          );
          break;
      }
    }).toList();

    userSport = userSport.copyWith(gender: _selectedGender);
    widgets.add(
      LookingForWidget(
        initialState: _selectedGender,
        onPressed: (Gender gender) {
          setState(() {
            _selectedGender = gender;
          });

          userSport = userSport.copyWith(gender: _selectedGender);
        },
      ),
    );
    return widgets;
  }

  _saveActivity(BuildContext context) {
    if (widget.showtype == SelectAbilityEnum.edit) {
      print("Save Ability");
      BlocProvider.of<EditAbilityBloc>(context).add(
        SaveAbilityEvent(
          userSport: userSport,
          height: _height,
          weight: _weight,
        ),
      );
    } else {
      print("Save  and Select Ability");
      BlocProvider.of<EditAbilityBloc>(context).add(
        SaveSelectedAbilityEvent(
          userSport: userSport,
          height: _height,
          weight: _weight,
        ),
      );
    }
  }
}
