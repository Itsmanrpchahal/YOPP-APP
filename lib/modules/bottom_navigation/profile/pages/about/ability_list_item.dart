import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yopp/helper/url_constants.dart';
import 'package:yopp/modules/bottom_navigation/filter/filter_dialog.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/widgets/buttons/gradient_check_button.dart';

import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';

import '../../bloc/profile_event.dart';

class AbilityCard extends StatelessWidget {
  const AbilityCard({
    Key key,
    @required this.itemWidth,
    @required this.padding,
    @required this.interest,
    @required this.isSelected,
    @required this.enabled,
  }) : super(key: key);

  final double itemWidth;
  final double padding;
  final Interest interest;
  final bool isSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height;
    final iconSize = min(itemWidth, (totalHeight / 3) - (3 * padding)) / 6;

    String name = "";
    if (interest.subCategory?.name != null) {
      name = interest.subCategory.name;
    } else if (interest.category?.name != null) {
      name = interest.category.name;
    } else if (interest.interest?.name != null) {
      name = interest.interest.name;
    }

    String imageUrl = "";
    final interestsOptions = context.watch<ProfileBloc>().state.interestOptions;
    interestsOptions.forEach((interestOption) {
      if (interestOption.id == interest.interest.id) {
        imageUrl = UrlConstants.interestImageUrl(interestOption.image);

        interestOption.category.forEach((categoryOption) {
          if (categoryOption.id == interest.category.id) {
            imageUrl = UrlConstants.categoryImageUrl(categoryOption.image);
          }
        });
      }
    });

    return InkWell(
      onTap: enabled && !isSelected ? () => _selectInterest(context) : null,
      onLongPress:
          enabled ? () => _showEditSportsOption(context, isSelected) : null,
      child: Container(
        width: itemWidth,
        margin: EdgeInsets.all(padding),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(itemWidth / 4),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: padding / 2,
                        offset: Offset(0, padding / 2)),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  interest == null
                      ? Container()
                      : Expanded(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(itemWidth / 4),
                            ),
                            child: CachedNetworkImage(
                                imageUrl: imageUrl ?? "",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Container()),
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
                        colors: [
                          Hexcolor("##030303").withOpacity(0.7),
                          Colors.transparent
                        ],
                      ),
                      borderRadius: BorderRadius.circular(itemWidth / 4),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.lightGrey
                            : Colors.transparent,
                        width: 4,
                      ),
                    ),
                  ),
            Container(
              width: itemWidth,
              height: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 10, left: 2, right: 2),
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
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
                onTap: () => _editInterest(context, isSelected),
                leading: Icon(Icons.edit),
                title: Text('Edit '),
              ),
              isSelectedCard
                  ? Container()
                  : ListTile(
                      onTap: () => _deleteInterest(context),
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

  void _selectInterest(BuildContext context) {
    print("select");
    BlocProvider.of<ProfileBloc>(context, listen: false)
        .add(SelectInterestEvent(interest));
  }

  _editInterest(BuildContext context, bool isSelected) async {
    final availableInterest =
        BlocProvider.of<ProfileBloc>(context, listen: false)
            .state
            .interestOptions;
    final interestToBeUpdate = await InterestDialog.show(
      context,
      availableInterests: availableInterest,
      interest: interest,
    );

    if (interestToBeUpdate != null) {
      if (isSelected) {
        context
            .read<ProfileBloc>()
            .add(UpdatePreferedInterestEvent(interest: interestToBeUpdate));
      } else {
        context
            .read<ProfileBloc>()
            .add(UpdateInterestEvent(interest: interestToBeUpdate));
      }
    }
    Navigator.of(context).pop();
  }

  _deleteInterest(BuildContext context) {
    BlocProvider.of<ProfileBloc>(context, listen: false)
        .add(DeleteInterestEvent(interest.id));
    Navigator.of(context).pop();
  }
}
