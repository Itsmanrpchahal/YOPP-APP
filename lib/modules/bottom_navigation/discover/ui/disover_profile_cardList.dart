import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tcard/tcard.dart';
import 'package:yopp/modules/_common/sports/sports.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_bloc.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_event.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

import 'discover_profile_card.dart';

class DiscoverProfileCardList extends StatelessWidget {
  const DiscoverProfileCardList({
    Key key,
    @required TCardController controller,
    @required this.height,
    @required this.padding,
    @required this.users,
    @required this.user,
  })  : controller = controller,
        super(key: key);

  final TCardController controller;

  final double height;
  final double padding;
  final List<DiscoveredUser> users;
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final iconPath = getAllSports()
        .firstWhere((element) => element.id == user.selectedSport.sportId)
        .imagePath;
    return AspectRatio(
      aspectRatio: 0.66,
      child: TCard(
        cards: List.generate(users.length, (index) {
          final distance = users[index].distance ~/ 1000;
          return DiscoverProfileCard(
            padding: padding,
            discoverdUser: users[index],
            height: height,
            distance: distance,
            iconString: iconPath,
          );
        }).toList(),
        controller: controller,
        onForward: (index, info) {
          if (info.direction == SwipDirection.Right) {
            BlocProvider.of<DiscoverBloc>(context)
                .add(LikeUserEvent(users.first));
          } else {
            BlocProvider.of<DiscoverBloc>(context)
                .add(DislikeUserEvent(users.first));
          }
        },
        onBack: (index) {
          print("on Back");
        },
        onEnd: () {
          print("on End");
        },
      ),
    );
  }
}
