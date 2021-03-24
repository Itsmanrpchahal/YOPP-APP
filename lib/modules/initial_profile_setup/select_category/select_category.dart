import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yopp/modules/_common/sports/sports.dart';

import 'package:yopp/modules/_common/sports/sports_category.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';

import 'package:yopp/modules/screens.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/body/half_gradient_scaffold.dart';
// import 'package:yopp/widgets/body/half_gradient_scaffold.dart';
import 'package:yopp/widgets/buttons/gradient_check_button.dart';

import 'check_list_tile.dart';

class SelectCategoryScreen extends StatefulWidget {
  static Route route(
          {@required int sportId,
          int subcategoryId,
          @required SelectAbilityEnum isInitialSetupScreen}) =>
      FadeRoute(
          builder: (_) => SelectCategoryScreen(
                sportId: sportId,
                subcategoryId: subcategoryId,
                showType: isInitialSetupScreen,
              ));

  final int sportId;
  final int subcategoryId;
  final SelectAbilityEnum showType;

  SelectCategoryScreen({
    Key key,
    @required this.sportId,
    this.subcategoryId,
    @required this.showType,
  }) : super(key: key);

  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  String categoryName;
  String imagePath;
  List<SportCategory> categories = [];

  @override
  void initState() {
    final allSports = getAllSports();
    final sport =
        allSports.where((element) => element.id == widget.sportId).first;
    imagePath = sport.imagePath;

    if (widget.subcategoryId == null) {
      categoryName = sport.name;
      if (sport.subCategory.isNotEmpty) {
        final array = sport.subCategory;
        array.sort((a, b) => a.name.compareTo(b.name));

        categories = array;
      }
      if (sport.styles.isNotEmpty) {
        final array = sport.styles;
        array.sort((a, b) => a.name.compareTo(b.name));
        categories = array;
      }
    } else if (widget.subcategoryId != null) {
      categoryName = sport.subCategory[widget.subcategoryId].name;
      final array = sport.subCategory[widget.subcategoryId].styles;
      array.sort((a, b) => a.name.compareTo(b.name));
      categories = array;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HalfGradientScaffold(
        titleText: "Select your Category",
        hideActionButton: true,
        onActionPressed: () {},
        firstHalf: _buildFirstHalf(context),
        secondHalf: _buildSecondHalf(context));
  }

  _buildFirstHalf(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SvgPicture.asset(
              imagePath,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              GradientCheckButton(
                onPressed: null,
                radius: 18,
              ),
              SizedBox(width: 20),
              Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildSecondHalf(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          // shrinkWrap: true,
          children: categories
              .map((category) => CustomCheckBoxListTile(
                  value: false,
                  title: category.name,
                  onChanged: (value) {
                    _saveCategory(context, category.id);
                  }))
              .toList()),
    );
  }

  _saveCategory(BuildContext context, int categoryId) {
    final selectedCategory =
        categories.firstWhere((element) => element.id == categoryId);

    if (selectedCategory is SportsSubCategory) {
      _showSubCategoryScreen(context, selectedCategory);
    }

    if (selectedCategory is SportStyle) {
      _showSelectAbilityScreen(context, selectedCategory);
    }
  }

  _showSubCategoryScreen(
      BuildContext context, SportsSubCategory selectedCategory) {
    Navigator.of(context).push(FadeRoute(
        builder: (_) => SelectCategoryScreen(
              showType: widget.showType,
              sportId: widget.sportId,
              subcategoryId: selectedCategory.id,
            )));
  }

  _showSelectAbilityScreen(BuildContext context, SportStyle selectedStyle) {
    Navigator.of(context).push(FadeRoute(
        builder: (_) => SelectAbilityScreen(
              userSport: UserSport(
                name: selectedStyle.name,
                sportId: widget.sportId,
                categoryId: widget.subcategoryId,
                styleId: selectedStyle.id,
              ),
              showtype: widget.showType,
            )));
  }
}
