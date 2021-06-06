import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/_common/ui/dot_indicator/dots_decorator.dart';
import 'package:yopp/modules/_common/ui/dot_indicator/dots_indicator.dart';
import 'package:yopp/modules/bottom_navigation/filter/cycling_level_list.dart';
import 'package:yopp/modules/bottom_navigation/filter/height_required_dialog.dart';
import 'package:yopp/modules/bottom_navigation/filter/bloc/interest_bloc.dart';
import 'package:yopp/modules/bottom_navigation/filter/bloc/interest_dialog_event.dart';
import 'package:yopp/modules/bottom_navigation/filter/bloc/interest_dialog_state.dart';
import 'package:yopp/modules/bottom_navigation/filter/pace_list.dart';
import 'package:yopp/modules/bottom_navigation/filter/running_level_list.dart';

import 'package:yopp/modules/bottom_navigation/filter/skill_level_filter.dart';
import 'package:yopp/modules/bottom_navigation/filter/interest_list_widget.dart';
import 'package:yopp/modules/bottom_navigation/filter/sport_style.dart';
import 'package:yopp/modules/bottom_navigation/filter/sport_subcategory.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_state.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

import 'gender_list.dart';

class InterestDialog {
  static Future<Interest> show(
    BuildContext context, {
    Interest interest,
    @required List<InterestOption> availableInterests,
    bool refineFilter = false,
  }) async {
    var horizontalMargin = MediaQuery.of(context).size.height * 0.1;

    Interest updatedInterest = await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return BlocProvider<InterestDialogBloc>(
          create: (BuildContext context) => InterestDialogBloc(
            InterestDialogState(
                interestOptions: availableInterests,
                interestToBeUpdate: interest),
          )..add(LoadInterestDialogEvent(
              interestOptions: availableInterests,
              selectedInterest: interest,
              refineFilter: refineFilter)),
          child: Container(
            margin: EdgeInsets.only(
                left: 32,
                right: 32,
                top: horizontalMargin,
                bottom: horizontalMargin),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2), color: Colors.white),
            child: Material(
                color: Colors.white,
                child: StatefulBuilder(builder: (context, setState) {
                  return BlocConsumer<InterestDialogBloc, InterestDialogState>(
                      builder: (context, state) {
                    return Column(
                      children: [
                        Container(
                          child: BlocListener<ProfileBloc, ProfileState>(
                            listener: (context, profileState) {
                              if (state.currentIndex == 0 &&
                                  profileState.status ==
                                      ProfileServiceStatus
                                          .updatedAndAddSportPending) {
                                print("objecfsfsfsfst" +
                                    profileState.status.toString());
                                final interest = state.interestOptions
                                    .firstWhere(
                                        (element) => element.name == "Dancing",
                                        orElse: () =>
                                            state.interestOptions.first);
                                context.read<InterestDialogBloc>().add(
                                    InterestOptionSelectedEvent(interest,
                                        height:
                                            profileState.userProfile.height));
                              } else if (state.currentIndex == 0 &&
                                  profileState.status ==
                                      ProfileServiceStatus.updateFailed) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(),
                          ),
                        ),
                        Expanded(
                            child: IndexedStack(
                          index: state.currentIndex,
                          children: state.filterOptions.map((filterOption) {
                            switch (filterOption) {
                              case FilterOptions.interest:
                                return InterestListWidget(
                                  interestOptions: state.interestOptions,
                                  onTap: (selected) {
                                    context.read<InterestDialogBloc>().add(
                                        InterestOptionSelectedEvent(selected,
                                            height: context
                                                .read<ProfileBloc>()
                                                .state
                                                ?.userProfile
                                                ?.height));
                                  },
                                  selectedInterestId:
                                      state.selectedInterestOption?.id,
                                );
                                break;
                              case FilterOptions.category:
                                return CategoryListWidget(
                                  onBack: () {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(OnBackEvent());
                                  },
                                  onSelected: (selected) {
                                    context.read<InterestDialogBloc>().add(
                                        CategoryOptionSelectedEvent(selected));
                                  },
                                  selectedCategoryId:
                                      state.selectedCategoryOption?.id,
                                  selectedInterestOption:
                                      state.selectedInterestOption,
                                );
                                break;
                              case FilterOptions.subcategory:
                                return SubCategoryListWidget(
                                  onBack: () {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(OnBackEvent());
                                  },
                                  onTap: (selected) {
                                    context.read<InterestDialogBloc>().add(
                                        SubCategoryOptionSelectedEvent(
                                            selected));
                                  },
                                  selectedSubCategoryId:
                                      state.selectedSubCategoryOption?.id,
                                  selectedCategory:
                                      state.selectedCategoryOption,
                                );
                                break;
                              case FilterOptions.skillList:
                                return SkillLevelList(
                                  onBack: () {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(OnBackEvent());
                                  },
                                  onSelected: (skillLevel) {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(SkillSelectedEvent(skillLevel));
                                  },
                                  selectedSkillLevel: state.skillLevel,
                                  previousScreenName: state.title,
                                  previousSelection: state.subtitle,
                                );
                                break;
                              case FilterOptions.cyclingDistance:
                                return CyclingLevelList(
                                  onBack: () {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(OnBackEvent());
                                  },
                                  onSelected: (level) {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(CylclingLevelSelectedEvent(level));
                                  },
                                  level: state.cyclingLevel,
                                  previousScreenName: state.title,
                                  previousSelection: state.subtitle,
                                );
                                break;
                              case FilterOptions.runningDistance:
                                return RunningLevelList(
                                  onBack: () {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(OnBackEvent());
                                  },
                                  onSelected: (level) {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(RunningLevelSelectedEvent(level));
                                  },
                                  level: state.runningLevel,
                                  previousScreenName: state.title,
                                  previousSelection: state.subtitle,
                                );
                                break;
                              case FilterOptions.pace:
                                return PaceLevelList(
                                  onBack: () {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(OnBackEvent());
                                  },
                                  onSelected: (level) {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(PaceSelectedEvent(level));
                                  },
                                  selectedPaceLevel: state.paceLevel,
                                  previousScreenName: state.title,
                                  previousSelection: state.subtitle,
                                );

                                break;
                              case FilterOptions.height:
                                return Container();
                                break;
                              case FilterOptions.gender:
                                return GenderList(
                                  previousScreenName: state.title,
                                  previousSelection: state.subtitle,
                                  onBack: () {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(OnBackEvent());
                                  },
                                  onSelected: (gender) {
                                    context
                                        .read<InterestDialogBloc>()
                                        .add(GenderSelectedEvent(gender));
                                  },
                                  selectedGender: state.gender,
                                );
                                break;
                            }
                          }).toList(),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: DotsIndicator(
                            dotsCount: state.filterOptions.length == 0
                                ? 1
                                : state.filterOptions.length,
                            position: state.currentIndex.toDouble(),
                            onTap: (position) {
                              // context.read<InterestDialogBloc>().add(event)
                            },
                            decorator: DotsDecorator(
                              color: AppColors.lightGrey,
                              activeColor: AppColors.green,
                              showInactiveBorder: false,
                            ),
                          ),
                        )
                      ],
                    );
                  }, listener: (context, state) async {
                    print("object");
                    print(state.filterOptions.toString());
                    if (state.heightRequired) {
                      HeightRequiredDialog.show(context);
                    } else if (state.complete) {
                      print(state.interestToBeUpdate?.toJson() ?? "NA");
                      Navigator.of(context).pop(state.interestToBeUpdate);
                    }
                  });
                })),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );

    return updatedInterest;
  }
}
