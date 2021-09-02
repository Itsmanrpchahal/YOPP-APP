import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/bottom_navigation/filter/filter_dialog.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

import '../../pages/about/ability_list_item.dart';

class AbilityListView extends StatefulWidget {
  final bool editable;
  final List<Interest> interests;
  final Interest selectedInterest;
  final Function onAddingNewSport;

  AbilityListView({
    Key key,
    this.interests = const [],
    @required this.selectedInterest,
    this.editable = true,
    this.onAddingNewSport,
  }) : super(key: key);

  @override
  _AbilityListViewState createState() => _AbilityListViewState();
}

class _AbilityListViewState extends State<AbilityListView> {
  ScrollController _scrollController;
  bool maxScrolled = false;

  double _padding = 4.0;

  double _itemWidth = 75.0;
  double _itemHeight = 112.0;

  initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          if (!maxScrolled) {
            setState(() {
              maxScrolled = true;
            });
          }
        } else {
          if (maxScrolled) {
            setState(() {
              maxScrolled = false;
            });
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
    final _totalwidth = MediaQuery.of(context).size.width - 64;
    // print("maxScrolled:" + maxScrolled.toString());
    // print(widget.interests.length);
    // print(_itemWidth);
    // print(_padding);
    // print(_totalwidth);

    final _scrollContentWidth = (_itemWidth * (widget.interests.length + 1)) +
        widget.interests.length * _padding;
    // print(_scrollContentWidth);

    // widget.sports.sort((a, b) => a.name.compareTo(b.name));

    return Container(
      height: _itemHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: _itemHeight,
            child: ListView.builder(
                padding: EdgeInsets.only(left: _padding, right: _padding),
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: widget.editable
                    ? widget.interests.length + 1
                    : widget.interests.length,
                itemBuilder: (context, index) {
                  if (widget.editable && index == widget.interests.length) {
                    return _buildAddMoreCard(context,
                        itemWidth: _itemWidth, padding: _padding);
                  } else {
                    return AbilityCard(
                        itemWidth: _itemWidth,
                        padding: _padding,
                        interest: widget.interests[index],
                        enabled: widget.editable,
                        isSelected: widget.interests[index].id ==
                            widget.selectedInterest?.id);
                  }
                }),
          ),
          !maxScrolled && _scrollContentWidth > _totalwidth
              ? Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black38,
                    mini: true,
                    child: Icon(Icons.chevron_right_outlined),
                    onPressed: () {
                      final offset =
                          _scrollController.offset + _totalwidth - 2 * _padding;
                      _scrollController.animateTo(offset,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.decelerate);
                    },
                  ))
              : Container(),
        ],
      ),
    );
  }

  Widget _buildAddMoreCard(BuildContext context,
      {double itemWidth, double padding}) {
    return InkWell(
      onLongPress: () {},
      onTap: () => _addInterest(context),
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

  _addInterest(BuildContext context) async {
    final availableInterest =
        BlocProvider.of<ProfileBloc>(context, listen: false)
            .state
            .interestOptions;

    final interestToBeUpdate = await InterestDialog.show(
      context,
      availableInterests: availableInterest,
      interest: null,
    );

    if (interestToBeUpdate != null) {
      context
          .read<ProfileBloc>()
          .add(AddNewInterestEvent(interest: interestToBeUpdate));
    }
  }
}
