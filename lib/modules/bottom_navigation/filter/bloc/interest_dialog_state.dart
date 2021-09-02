import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/_common/sports/data/requirements/cycling_requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/running-requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

enum InterestDialogOption { add, edit }

enum FilterOptions {
  interest,
  category,
  subcategory,
  skillList,
  cyclingDistance,
  runningDistance,
  pace,
  height,
  gender,
}

class InterestDialogState extends Equatable {
  final InterestDialogOption option;
  final int currentIndex;
  final List<FilterOptions> filterOptions;

  final InterestOption selectedInterestOption;
  final CategoryOption selectedCategoryOption;
  final SubCategoryOption selectedSubCategoryOption;

  final List<InterestOption> interestOptions;
  final List<CategoryOption> categoryOptions;
  final List<SubCategoryOption> subCategoryOptions;

  final SkillLevel skillLevel;
  final PaceLevel paceLevel;
  final CyclingLevel cyclingLevel;
  final RunningLevel runningLevel;

  final Gender gender;
  final bool complete;

  String get title {
    String value = "";
    if (currentIndex == 0) {
      value += "Selected Sport";
    }
    if (currentIndex > 0 && filterOptions.length > 0) {
      value += "Change Selected ";
      final previousOption = filterOptions.elementAt(currentIndex - 1);
      switch (previousOption) {
        case FilterOptions.interest:
          value += "Category";
          break;
        case FilterOptions.category:
          value += "Sub-Category";
          break;
        case FilterOptions.subcategory:
          value += "Style";
          break;
        case FilterOptions.skillList:
          value += "Skill Level";
          break;
        case FilterOptions.cyclingDistance:
          value += "Distance";
          break;
        case FilterOptions.pace:
          value += "Pace";
          break;
        case FilterOptions.height:
          value += "Height";
          break;
        case FilterOptions.gender:
          value += "Gender";
          break;
        case FilterOptions.runningDistance:
          value += "Distance";
          break;
      }
    }
    return value;
  }

  String get subtitle {
    String value = "";

    if (currentIndex == 0) {
      if (selectedSubCategoryOption != null) {
        value += selectedSubCategoryOption.name;
      } else if (selectedCategoryOption != null) {
        value += selectedCategoryOption.name;
      } else if (selectedInterestOption != null) {
        value += selectedInterestOption.name;
      }
    }

    if (currentIndex > 0 && filterOptions.length > 0) {
      final previousOption = filterOptions.elementAt(currentIndex - 1);
      switch (previousOption) {
        case FilterOptions.interest:
          value = selectedInterestOption.name;
          break;
        case FilterOptions.category:
          value = selectedCategoryOption.name;
          break;
        case FilterOptions.subcategory:
          value = selectedSubCategoryOption.name;
          break;
        case FilterOptions.skillList:
          value = skillLevel.name;
          break;
        case FilterOptions.cyclingDistance:
          value = cyclingLevel.name;
          break;
        case FilterOptions.pace:
          value = paceLevel.name;
          break;
        case FilterOptions.height:
          value = "";
          break;
        case FilterOptions.gender:
          value = gender.name;
          break;
        case FilterOptions.runningDistance:
          value = runningLevel.name;
          break;
      }
    }
    return value;
  }

  final bool heightRequired;
  final bool refineFilter;

  final Interest interestToBeUpdate;

  InterestDialogState({
    this.option = InterestDialogOption.add,
    this.currentIndex = 0,
    this.selectedInterestOption,
    this.selectedCategoryOption,
    this.selectedSubCategoryOption,
    this.interestOptions = const [],
    this.categoryOptions = const [],
    this.subCategoryOptions = const [],
    this.skillLevel,
    this.paceLevel,
    this.cyclingLevel,
    this.runningLevel,
    this.gender,
    this.heightRequired = false,
    this.complete = false,
    this.refineFilter = false,
    this.filterOptions = const [],
    this.interestToBeUpdate,
  });

  InterestDialogState copyWith({
    int currentIndex,
    InterestOption selectedInterestOption,
    CategoryOption selectedCategoryOption,
    SubCategoryOption selectedSubCategoryOption,
    List<InterestOption> interestOptions,
    List<CategoryOption> categoryOptions,
    List<SubCategoryOption> subCategoryOptions,
    SkillLevel skillLevel,
    PaceLevel paceLevel,
    CyclingLevel cyclingLevel,
    RunningLevel runningLevel,
    Gender gender,
    bool complete,
    Interest interestToBeUpdate,
    bool heightRequired,
    bool refineFilter,
    List<FilterOptions> filterOptions,
  }) {
    return InterestDialogState(
      currentIndex: currentIndex ?? this.currentIndex,
      selectedInterestOption:
          selectedInterestOption ?? this.selectedInterestOption,
      selectedCategoryOption:
          selectedCategoryOption ?? this.selectedCategoryOption,
      selectedSubCategoryOption:
          selectedSubCategoryOption ?? this.selectedSubCategoryOption,
      interestOptions: interestOptions ?? this.interestOptions,
      categoryOptions: categoryOptions ?? this.categoryOptions,
      subCategoryOptions: subCategoryOptions ?? this.subCategoryOptions,
      skillLevel: skillLevel ?? this.skillLevel,
      paceLevel: paceLevel ?? this.paceLevel,
      cyclingLevel: cyclingLevel ?? this.cyclingLevel,
      runningLevel: runningLevel ?? this.runningLevel,
      gender: gender ?? this.gender,
      complete: complete ?? false,
      interestToBeUpdate: interestToBeUpdate ?? this.interestToBeUpdate,
      heightRequired: heightRequired ?? this.heightRequired,
      refineFilter: refineFilter ?? this.refineFilter,
      filterOptions: filterOptions ?? this.filterOptions,
    );
  }

  @override
  List<Object> get props => [
        this.option,
        this.currentIndex,
        this.selectedInterestOption,
        this.selectedCategoryOption,
        this.selectedSubCategoryOption,
        this.interestOptions,
        this.categoryOptions,
        this.subCategoryOptions,
        this.skillLevel,
        this.paceLevel,
        this.cyclingLevel,
        this.runningLevel,
        this.gender,
        this.complete,
        this.interestToBeUpdate,
        this.heightRequired,
        this.refineFilter
      ];
}
