import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/sports/data/requirements/running-requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/cycling_requirements.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';

import 'package:yopp/widgets/icons/profile_icon.dart';

class DiscoverProfileWidget extends StatefulWidget {
  final double width;
  final double height;
  final DiscoveredUserData userProfile;

  const DiscoverProfileWidget({
    Key key,
    @required this.width,
    @required this.height,
    @required this.userProfile,
  }) : super(key: key);

  @override
  _DiscoverProfileWidgetState createState() => _DiscoverProfileWidgetState();
}

class _DiscoverProfileWidgetState extends State<DiscoverProfileWidget> {
  var showDetail = false;

  @override
  Widget build(BuildContext context) {
    var skillLevel = "Skill Level - ";
    String userHeight;
    String pace;
    String distance;

    if (widget?.userProfile?.selectedInterest != null) {
      skillLevel += widget?.userProfile?.selectedInterest?.skill?.name ?? "";
      if (widget.userProfile.selectedInterest.interest == "Dancing" &&
          widget.userProfile?.height != null) {
        userHeight =
            "Height - " + (widget.userProfile?.height ?? "").toString() + " cm";
      }

      if (widget.userProfile.selectedInterest.pace != null) {
        pace = "Pace Level - " + widget.userProfile.selectedInterest.pace.name;
      }

      if (widget.userProfile.selectedInterest.cyclingLevel != null) {
        distance = "Distance - " +
            widget.userProfile.selectedInterest.cyclingLevel.name;
      }

      if (widget.userProfile.selectedInterest.runningLevel != null) {
        distance = "Distance - " +
            widget.userProfile.selectedInterest.runningLevel.name;
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          showDetail = !showDetail;
        });
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          color: AppColors.lightGrey,
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: showDetail
              ? Container(
                  height: widget.height,
                  width: widget.width,
                  padding: EdgeInsets.all(8.0),
                  color: AppColors.darkGrey,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              widget?.userProfile?.about ?? " ",
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              maxLines: 10,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        userHeight == null
                            ? Container()
                            : FittedBox(
                                child: Text(
                                  userHeight,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                        distance == null
                            ? Container()
                            : FittedBox(
                                child: Text(
                                  distance,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                        pace == null
                            ? Container()
                            : FittedBox(
                                child: Text(
                                  pace,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                        FittedBox(
                          child: Text(
                            skillLevel,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                    child: ProfileIcon(
                      imageUrl: widget.userProfile?.avatar,
                      gender: widget.userProfile?.gender,
                    ),
                  ),
                ),
          transitionBuilder: (child, animation) {
            final offsetAnimation =
                Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
