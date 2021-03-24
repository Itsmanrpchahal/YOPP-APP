import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/bottom_navigation/bottom_nav_appBar.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/ui/chat_detail_screen.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/bottom_navigation/matched/bloc/matched_bloc.dart';
import 'package:yopp/modules/bottom_navigation/matched/bloc/matched_event.dart';
import 'package:yopp/modules/bottom_navigation/matched/bloc/matched_state.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/icons/default_user_icon.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class MatchedScreen extends StatefulWidget {
  static Route route({
    @required UserProfile user,
    @required DiscoveredUser matchedUser,
  }) =>
      FadeRoute(
          builder: (_) => MatchedScreen(
                user: user,
                matchedUser: matchedUser,
              ));

  const MatchedScreen({
    Key key,
    @required this.user,
    @required this.matchedUser,
  }) : super(key: key);

  final UserProfile user;
  final DiscoveredUser matchedUser;

  @override
  _MatchedScreenState createState() => _MatchedScreenState();
}

class _MatchedScreenState extends State<MatchedScreen> {
  ChatDescription chatDescription;

  @override
  void initState() {
    super.initState();
    createChatRoom(context);
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      body: BlocListener<MatchedBloc, MatchedState>(
          listener: (context, state) {
            switch (state.status) {
              case ServiceStatus.initial:
                break;
              case ServiceStatus.loading:
                ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.loading, state.message);
                break;
              case ServiceStatus.success:
                setState(() {
                  chatDescription = state.chatDescription;
                });

                // ProgressHud.of(context)
                //     .showAndDismiss(ProgressHudType.success, state.message);
                // Navigator.of(context).pop(state.chatDescription);

                break;
              case ServiceStatus.failure:
                ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.error, state.message);
                break;
            }
          },
          child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top;
    final width = MediaQuery.of(context).size.width;

    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          height: height * 0.4,
          child: Center(
            child: _buildProfilesIcons(
              context,
              height / 2,
              width,
            ),
          ),
        ),
        _buildLowerSection(
          context: context,
          height: height * 0.6,
        )
      ],
    );
  }

  Widget _buildProfilesIcons(
      BuildContext context, double height, double width) {
    final iconDiameter = min(height, width) / 2;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Transform.translate(
            offset: Offset(iconDiameter * 0.4, 0),
            child: _buildProfileIcon(context, iconDiameter,
                widget.matchedUser?.avatar, widget.matchedUser?.gender, false)),
        Transform.translate(
            offset: Offset(-iconDiameter * 0.3, 0),
            child: _buildProfileIcon(context, iconDiameter, widget.user?.avatar,
                widget.user.gender, true)),
      ],
    );
  }

  Widget _buildProfileIcon(
    BuildContext context,
    double height,
    String imageurl,
    Gender gender,
    bool bigger,
  ) {
    final diameter = bigger == true ? height : height * 0.8;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: imageurl ?? "",
          imageBuilder: (context, imageProvider) => Container(
            height: diameter,
            width: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: bigger ? AppColors.lightGrey : Hexcolor("#A09EE0"),
                width: diameter / 20,
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
              ),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            height: diameter,
            width: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: bigger ? AppColors.lightGrey : Hexcolor("#A09EE0"),
                width: diameter / 20,
              ),
            ),
            child: Container(
                margin: EdgeInsets.all(diameter / 6),
                child: gender == null
                    ? Container()
                    : gender == Gender.male
                        ? MaleIcon()
                        : FemaleIcon()),
          ),
        ),
        bigger
            ? Positioned(
                left: 0,
                top: 0,
                child: CircleAvatar(
                  radius: diameter / 8,
                  backgroundColor: Hexcolor("#A09EE0"),
                  child: CircleAvatar(
                    radius: diameter / 9,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      widget.user.selectedSport.getImagepath(),
                      fit: BoxFit.contain,
                      height: diameter / 9,
                      width: diameter / 9,
                    ),
                  ),
                ),
              )
            : Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: diameter / 8,
                  backgroundColor: Hexcolor("#A09EE0"),
                  child: CircleAvatar(
                    radius: diameter / 9,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      widget.user.selectedSport.getImagepath(),
                      fit: BoxFit.contain,
                      height: diameter / 9,
                      width: diameter / 9,
                    ),
                  ),
                ),
              )
      ],
    );
  }

  Widget _buildLowerSection({
    BuildContext context,
    double height,
  }) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Matched!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 72,
            ),
          ),
          Text(
            "You and " +
                (widget.matchedUser?.name ?? "") +
                " are perfect practise partners.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Spacer(flex: 2),
          Container(
            color: AppColors.orange,
            height: 4,
            width: 40,
          ),
          Spacer(flex: 8),
          CircleIconButton(
            radius: 40,
            onPressed: () => showChatDetailScreen(context, chatDescription),
            icon: Icon(
              CupertinoIcons.chat_bubble_2_fill,
              color: AppColors.orange,
              size: 40,
            ),
          ),
          Spacer(flex: 1),
          Text(
            "Start Chatting!",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Spacer(flex: 8),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Keep Swiping",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  void showChatDetailScreen(
      BuildContext context, ChatDescription chatDescription) {
    if (chatDescription == null) {
      createChatRoom(context);
    } else {
      Navigator.of(context).push(ChatDetailScreen.route(chatDescription));
    }
  }

  void createChatRoom(BuildContext context) {
    BlocProvider.of<MatchedBloc>(context)
        .add(MatchedUserEvent(widget.user, widget.matchedUser));
  }
}
