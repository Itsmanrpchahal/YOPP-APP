import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';
import 'package:yopp/modules/screens.dart';

import 'ability_list_item.dart';

class AbilityListView extends StatelessWidget {
  final bool editable;
  final List<UserSport> sports;
  final String selectedSport;
  final Function onAddingNewSport;

  const AbilityListView({
    Key key,
    this.sports = const [],
    @required this.selectedSport,
    this.editable = true,
    this.onAddingNewSport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = 8.0;
    final totalwidth = MediaQuery.of(context).size.width;
    final itemWidth = (totalwidth / 3) - (3 * padding);

    sports.sort((a, b) => a.name.compareTo(b.name));

    return Container(
      color: Hexcolor("#F4F2F2"),
      padding: EdgeInsets.all(padding),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: editable ? sports.length + 1 : sports.length,
          itemBuilder: (context, index) {
            if (editable && index == sports.length) {
              return _buildAddMoreCard(context,
                  itemWidth: itemWidth, padding: padding);
            } else {
              return AbilityCard(
                  itemWidth: itemWidth,
                  padding: padding,
                  sport: sports[index],
                  enabled: editable,
                  isSelected: sports[index].name == selectedSport);
            }
          }),
    );
  }

  Widget _buildAddMoreCard(BuildContext context,
      {double itemWidth, double padding}) {
    return InkWell(
      onLongPress: () {},
      onTap: () {
        Navigator.of(context)
            .push(SelectActivityScreen.route(
                isInitialSetupScreen: SelectAbilityEnum.addAnother))
            .then((value) => onAddingNewSport());
      },
      child: Container(
        width: itemWidth,
        margin: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(itemWidth / 4)),
        child: Icon(
          Icons.add,
          size: itemWidth / 2,
          color: Colors.white,
        ),
      ),
    );
  }
}
