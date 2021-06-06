import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/bottom_navigation/filter/bloc/interest_dialog_event.dart';
import 'package:yopp/modules/bottom_navigation/filter/bloc/interest_dialog_state.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

class InterestDialogBloc
    extends Bloc<InterestDialogEvent, InterestDialogState> {
  InterestDialogBloc(InterestDialogState initialState) : super(initialState);

  @override
  Stream<InterestDialogState> mapEventToState(
      InterestDialogEvent event) async* {
    print(event.toString());
    if (event is LoadInterestDialogEvent) {
      if (event.selectedInterest == null) {
        yield state.copyWith(
          currentIndex: 0,
          interestOptions: event.interestOptions,
          interestToBeUpdate: new Interest(),
          filterOptions: event.refineFilter
              ? [
                  FilterOptions.interest,
                  FilterOptions.gender,
                ]
              : [
                  FilterOptions.interest,
                  FilterOptions.skillList,
                  FilterOptions.gender
                ],
          refineFilter: event.refineFilter,
        );
      } else {
        List<CategoryOption> categoryOptions = [];
        CategoryOption selectedCategoryOption;
        List<SubCategoryOption> subCategoryOptions = [];
        SubCategoryOption selectedSubCategoryOption;

        final selectedInterestOption = event.interestOptions.firstWhere(
            (element) => element.id == event.selectedInterest.interest.id);

        if (selectedInterestOption != null) {
          categoryOptions = selectedInterestOption.category;

          if (categoryOptions.isNotEmpty) {
            selectedCategoryOption = categoryOptions.firstWhere(
                (element) => element.id == event.selectedInterest.category.id);

            subCategoryOptions = selectedCategoryOption.subCategory;
            if (subCategoryOptions.isNotEmpty) {
              selectedSubCategoryOption = subCategoryOptions.firstWhere(
                  (element) =>
                      element.id == event.selectedInterest.subCategory.id);
            }
          }
        }

        List<FilterOptions> filterOptions = [];

        if (event.refineFilter) {
          filterOptions.add(FilterOptions.interest);
          if (categoryOptions.isNotEmpty) {
            filterOptions.add(FilterOptions.category);
          }
          if (subCategoryOptions.isNotEmpty) {
            filterOptions.add(FilterOptions.subcategory);
          }
          filterOptions.addAll([FilterOptions.gender]);
        } else {
          filterOptions = [
            FilterOptions.skillList,
            FilterOptions.gender,
          ];
        }

        yield state.copyWith(
          currentIndex: event.refineFilter ? filterOptions.length - 2 : 0,
          interestOptions: event.refineFilter ? event.interestOptions : [],
          selectedInterestOption: selectedInterestOption,
          categoryOptions: event.refineFilter ? categoryOptions : [],
          selectedCategoryOption: selectedCategoryOption,
          subCategoryOptions: event.refineFilter ? subCategoryOptions : [],
          selectedSubCategoryOption: selectedSubCategoryOption,
          interestToBeUpdate: event.selectedInterest,
          skillLevel: event.selectedInterest.skill,
          paceLevel: event.selectedInterest.pace,
          cyclingLevel: event.selectedInterest.cyclingLevel,
          runningLevel: event.selectedInterest.runningLevel,
          gender: event.selectedInterest.gender,
          refineFilter: event.refineFilter,
          filterOptions: filterOptions,
        );
      }
    }

    if (event is InterestOptionSelectedEvent) {
      bool heightRequired = false;

      if (event.selectedInterestOption.name == "Dancing") {
        if (event.height == null) {
          heightRequired = true;
        }
      }

      if (heightRequired) {
        yield state.copyWith(
          heightRequired: true,
        );
        yield state.copyWith(
          heightRequired: false,
        );
        return;
      }

      List<FilterOptions> filterOptions = state.filterOptions;
      if (event.selectedInterestOption.category.isNotEmpty) {
        if (!state.filterOptions.contains(FilterOptions.category)) {
          print(filterOptions);
          filterOptions.insert(state.currentIndex + 1, FilterOptions.category);
          print(filterOptions);
        }
      }

      yield state.copyWith(
        currentIndex: state.currentIndex + 1,
        selectedInterestOption: event.selectedInterestOption,
        categoryOptions: event.selectedInterestOption.category,
        interestToBeUpdate: new Interest(
          interest: IdNameImage(
            id: event.selectedInterestOption.id,
            name: event.selectedInterestOption.name,
          ),
        ),
        heightRequired: false,
        filterOptions: filterOptions,
      );
    }

    if (event is CategoryOptionSelectedEvent) {
      List<FilterOptions> filterOptions = state.filterOptions;
      if (event.selectedCategoryOption.subCategory.isNotEmpty) {
        if (!state.filterOptions.contains(FilterOptions.subcategory)) {
          filterOptions.insert(
              state.currentIndex + 1, FilterOptions.subcategory);
        }
      }

      yield state.copyWith(
        currentIndex: state.currentIndex + 1,
        selectedCategoryOption: event.selectedCategoryOption,
        subCategoryOptions: event.selectedCategoryOption.subCategory,
        interestToBeUpdate: state.interestToBeUpdate.copyWith(
          category: IdNameImage(
            id: event.selectedCategoryOption.id,
            name: event.selectedCategoryOption.name,
          ),
        ),
        filterOptions: filterOptions,
      );
    }

    if (event is SubCategoryOptionSelectedEvent) {
      yield state.copyWith(
        currentIndex: state.currentIndex + 1,
        selectedSubCategoryOption: event.selectedSubCategoryOption,
        interestToBeUpdate: state.interestToBeUpdate.copyWith(
          subCategory: IdNameImage(
            id: event.selectedSubCategoryOption.id,
            name: event.selectedSubCategoryOption.name,
          ),
        ),
      );
    }

    if (event is SkillSelectedEvent) {
      List<FilterOptions> filterOptions = state.filterOptions;
      print(state.selectedInterestOption.name);
      if (state.selectedInterestOption.name == "Cycling") {
        filterOptions.insert(filterOptions.length - 1, FilterOptions.pace);
        filterOptions.insert(
            filterOptions.length - 1, FilterOptions.cyclingDistance);
      }

      if (state.selectedInterestOption.name == "Running") {
        filterOptions.insert(filterOptions.length - 1, FilterOptions.pace);
        filterOptions.insert(
            filterOptions.length - 1, FilterOptions.runningDistance);
      }

      yield state.copyWith(
        currentIndex: state.currentIndex + 1,
        skillLevel: event.skill,
        interestToBeUpdate: state.interestToBeUpdate.copyWith(
          skill: event.skill,
        ),
      );
    }

    if (event is PaceSelectedEvent) {
      yield state.copyWith(
        currentIndex: state.currentIndex + 1,
        paceLevel: event.paceLevel,
        interestToBeUpdate: state.interestToBeUpdate.copyWith(
          pace: event.paceLevel,
        ),
      );
    }

    if (event is CylclingLevelSelectedEvent) {
      yield state.copyWith(
        currentIndex: state.currentIndex + 1,
        cyclingLevel: event.level,
        interestToBeUpdate: state.interestToBeUpdate.copyWith(
          cyclingLevel: event.level,
        ),
      );
    }

    if (event is RunningLevelSelectedEvent) {
      yield state.copyWith(
        currentIndex: state.currentIndex + 1,
        runningLevel: event.level,
        interestToBeUpdate: state.interestToBeUpdate.copyWith(
          runningLevel: event.level,
        ),
      );
    }

    if (event is GenderSelectedEvent) {
      yield state.copyWith(complete: false);
      yield state.copyWith(
          gender: event.gender,
          interestToBeUpdate: state.interestToBeUpdate.copyWith(
            id: state.selectedSubCategoryOption != null
                ? state.selectedSubCategoryOption.id
                : state.selectedCategoryOption != null
                    ? state.selectedCategoryOption.id
                    : state.selectedInterestOption.id,
            gender: event.gender,
          ),
          complete: true);
    }

    if (event is OnBackEvent) {
      int index = state.currentIndex;

      List<FilterOptions> filterOptions = state.filterOptions;

      for (int index = state.currentIndex;
          index < filterOptions.length;
          index++) {
        final filterOption = state.filterOptions.elementAt(index);

        if ([
          FilterOptions.interest,
          FilterOptions.skillList,
          FilterOptions.gender,
        ].contains(filterOption)) {
          //don't remove
        } else {
          filterOptions.removeAt(index);
        }
      }

      if (index > 0) {
        index -= 1;
      }

      yield state.copyWith(
        currentIndex: index,
        filterOptions: filterOptions,
      );
    }

    yield state;
  }
}
