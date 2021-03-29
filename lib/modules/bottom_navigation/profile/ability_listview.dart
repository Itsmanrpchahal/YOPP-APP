import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';
import 'package:yopp/modules/screens.dart';

import 'ability_list_item.dart';

class AbilityListView extends StatefulWidget {
  final bool editable;
  final List<UserSport> sports;
  final String selectedSport;
  final Function onAddingNewSport;

  AbilityListView({
    Key key,
    this.sports = const [],
    @required this.selectedSport,
    this.editable = true,
    this.onAddingNewSport,
  }) : super(key: key);

  @override
  _AbilityListViewState createState() => _AbilityListViewState();
}

class _AbilityListViewState extends State<AbilityListView> {
  ScrollController _scrollController;
  bool showMoreArrow = true;

  initState() {
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            showMoreArrow = false;
          });
        } else {
          if (showMoreArrow == false) {
            showMoreArrow = true;
            setState(() {});
          }
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = 8.0;
    final totalwidth = MediaQuery.of(context).size.width;
    final itemWidth = (totalwidth / 3) - (3 * padding);

    widget.sports.sort((a, b) => a.name.compareTo(b.name));

    return Stack(
      children: [
        Container(
          color: Hexcolor("#F4F2F2"),
          child: ListView.builder(
              padding: EdgeInsets.only(left: padding, right: padding),
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: widget.editable
                  ? widget.sports.length + 1
                  : widget.sports.length,
              itemBuilder: (context, index) {
                if (widget.editable && index == widget.sports.length) {
                  return _buildAddMoreCard(context,
                      itemWidth: itemWidth, padding: padding);
                } else {
                  return AbilityCard(
                      itemWidth: itemWidth,
                      padding: padding,
                      sport: widget.sports[index],
                      enabled: widget.editable,
                      isSelected:
                          widget.sports[index].name == widget.selectedSport);
                }
              }),
        ),
        showMoreArrow && widget.sports.length > 2
            ? Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.black38,
                  mini: true,
                  child: Icon(Icons.chevron_right_outlined),
                  onPressed: () {
                    final offset =
                        _scrollController.offset + totalwidth - 2 * padding;
                    _scrollController.animateTo(offset,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.decelerate);
                  },
                ))
            : Container(),
      ],
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
            .then((value) => widget.onAddingNewSport());
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
