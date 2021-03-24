import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';
import 'package:yopp/widgets/buttons/gradient_check_button.dart';
import 'package:yopp/modules/_common/sports/sports.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/ability_list_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/ability_list_event.dart';

import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';

import 'package:yopp/modules/screens.dart';

class AbilityCard extends StatelessWidget {
  const AbilityCard({
    Key key,
    @required this.itemWidth,
    @required this.padding,
    @required this.sport,
    @required this.isSelected,
    @required this.enabled,
  }) : super(key: key);

  final double itemWidth;
  final double padding;
  final UserSport sport;
  final bool isSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height;
    final iconSize = min(itemWidth, (totalHeight / 3) - (3 * padding)) / 6;
    final sportDetail =
        getAllSports().firstWhere((element) => element.id == sport.sportId);

    return InkWell(
      onTap: enabled && !isSelected ? () => _selectSport(context) : null,
      onLongPress:
          enabled ? () => _showEditSportsOption(context, isSelected) : null,
      child: Container(
        width: itemWidth,
        margin: EdgeInsets.all(padding),
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(itemWidth / 4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sportDetail == null
                      ? Container()
                      : Expanded(
                          child: SvgPicture.asset(
                            sportDetail.imagePath,
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                ],
              ),
            ),
            isSelected
                ? Container(
                    width: itemWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Hexcolor("##030303").withOpacity(0.64),
                      borderRadius: BorderRadius.circular(itemWidth / 4),
                      border: Border.all(
                          color: isSelected
                              ? AppColors.lightGrey
                              : Colors.transparent,
                          width: 4),
                    ),
                  )
                : Container(
                    width: itemWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Hexcolor("##030303"), Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(itemWidth / 4),
                      border: Border.all(
                          color: isSelected
                              ? AppColors.lightGrey
                              : Colors.transparent,
                          width: 4),
                    ),
                  ),
            Container(
              width: itemWidth,
              height: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 10, left: 2, right: 2),
              child: Text(
                sport.name ?? sport.styleId.toString(),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            isSelected
                ? Container(
                    child: Center(
                      child: CheckButton(radius: iconSize, onPressed: null),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  _showEditSportsOption(BuildContext context, bool isSelectedCard) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: isSelectedCard ? 160 : 220,
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () => _editAbility(context, isSelected),
                leading: Icon(Icons.edit),
                title: Text('Edit '),
              ),
              isSelectedCard
                  ? Container()
                  : ListTile(
                      onTap: () => _deleteSport(context),
                      leading: Icon(Icons.delete_forever),
                      title: Text('Delete'),
                    ),
              Divider(),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop(null);
                },
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectSport(BuildContext context) {
    print("select");
    BlocProvider.of<AbilityListBloc>(context)
        .add(SelectSportAbilityEvent(sport));
  }

  _editAbility(BuildContext context, bool isSelected) async {
    await Navigator.of(context).push(SelectAbilityScreen.route(
        showtype: isSelected
            ? SelectAbilityEnum.selectedEdit
            : SelectAbilityEnum.edit,
        userSport: sport));
    Navigator.of(context).pop();
  }

  _deleteSport(BuildContext context) {
    BlocProvider.of<AbilityListBloc>(context)
        .add(DeleteSportAbilityEvent(sport.name));
    Navigator.of(context).pop();
  }
}
