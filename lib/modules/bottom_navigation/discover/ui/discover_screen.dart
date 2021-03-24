import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:tcard/tcard.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/app_gradients.dart';

import 'package:yopp/modules/bottom_navigation/bottom_nav_appBar.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_bloc.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/bottom_navigation/discover/ui/no_user_card.dart';
import 'package:yopp/modules/bottom_navigation/matched/matched_screen.dart';
import 'package:yopp/modules/bottom_navigation/bottom_nav_page.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/widgets/buttons/rounded_button.dart';

import '../bloc/discover_event.dart';
import '../bloc/discover_state.dart';
import 'background_card.dart';
import 'discover_buttons_container.dart';
import 'disover_profile_cardList.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({
    Key key,
  }) : super(key: key);
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TCardController _controller = TCardController();

  var enableMatchButton = false;

  @override
  void initState() {
    _refreshCards(context);
    super.initState();
  }

  void _refreshCards(BuildContext context) {
    BlocProvider.of<DiscoverBloc>(context).add(DiscoverUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BottomNavPage(
      enableGradient: true,
      child: Scaffold(
          appBar: BottomNavAppBar(
            context: context,
          ),
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: false,
          body: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          Expanded(
            child: _buildCards(
              context,
              constraints.maxHeight * 0.7,
              constraints.maxWidth,
            ),
          ),
          DiscoverButtonSection(
              enableMatchButton: enableMatchButton,
              height: constraints.maxHeight * 0.3,
              controller: _controller),
        ],
      );
    });
  }

  Widget _buildCards(BuildContext context, double height, double width) {
    final padding = math.min(height, width) / 6;

    return Container(
      child: Stack(
        children: [
          LeftBackground(
            padding: padding,
            height: height,
          ),
          RightBackground(
            padding: padding,
            height: height,
          ),
          Transform.scale(
            scale: 0.9,
            child: BlocConsumer<DiscoverBloc, DiscoverState>(
              builder: (context, state) {
                print(state.status.toString());
                switch (state.status) {
                  case DiscoverServiceStatus.loading:
                    return BackgroundCard(
                        height: height,
                        padding: padding,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ));
                    break;

                  case DiscoverServiceStatus.swping:
                    return BackgroundCard(
                        height: height,
                        padding: padding,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ));
                    break;

                  case DiscoverServiceStatus.noLocation:
                    return BackgroundCard(
                        height: height,
                        padding: padding,
                        child: OpenLocationSettingsWidget());
                    break;

                  default:
                    if (state.users.isEmpty) {
                      return BackgroundCard(
                        height: height,
                        padding: padding,
                        child: NoUserWidget(),
                      );
                    }
                    return DiscoverProfileCardList(
                        controller: _controller,
                        height: height,
                        padding: padding,
                        users: state.users,
                        user: state.user);
                }
              },
              listener: (context, state) {
                if (mounted) {
                  setState(() {
                    enableMatchButton = state.users.isNotEmpty;
                  });
                }

                if (state.status == DiscoverServiceStatus.matched) {
                  _showMatchedScreen(context,
                      matchedUser: state.matchedUser, user: state.user);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMatchedScreen(
    BuildContext context, {
    @required UserProfile user,
    @required DiscoveredUser matchedUser,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Navigator.of(context)
          .push(MatchedScreen.route(user: user, matchedUser: matchedUser));
    });
  }
}

class RightBackground extends StatelessWidget {
  const RightBackground({
    Key key,
    @required this.padding,
    @required this.height,
  }) : super(key: key);

  final double padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      alignment: Alignment.bottomRight,
      child: Transform.rotate(
          alignment: Alignment.bottomRight,
          angle: math.pi / 20,
          child: BackgroundCard(
              height: height, padding: padding, child: Container())),
    );
  }
}

class LeftBackground extends StatelessWidget {
  const LeftBackground({
    Key key,
    @required this.padding,
    @required this.height,
  }) : super(key: key);

  final double padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      alignment: Alignment.centerLeft,
      child: Transform.rotate(
          alignment: Alignment.bottomLeft,
          angle: -math.pi / 20,
          child: BackgroundCard(
              height: height, padding: padding, child: Container())),
    );
  }
}

class OpenLocationSettingsWidget extends BackgroundCard {
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppGradients.verticalLinearGradient),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Enable Location",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
                "Your location service need to be turned on in order to find a suitable practise partners nearby.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white70)),
            SizedBox(height: 12),
            Center(
                child:
                    Container(color: AppColors.orange, height: 2, width: 26)),
            SizedBox(height: 32),
            RoundedButton(
                titleText: "Open Settings",
                onPressed: () async {
                  bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
                  bool isAndroid =
                      Theme.of(context).platform == TargetPlatform.android;
                  if (isIOS) {
                    await Geolocator.openLocationSettings();
                  }

                  if (isAndroid) {
                    await Geolocator.openAppSettings();
                  }
                }),
          ],
        )),
      ),
    );
  }
}
