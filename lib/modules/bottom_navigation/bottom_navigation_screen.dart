import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yopp/modules/_common/models/database.dart';
import 'package:yopp/modules/_common/models/location_permission_status.dart';
import 'package:yopp/modules/bottom_navigation/chat/chatlist/chatlist_screen.dart';
import 'package:yopp/modules/bottom_navigation/custom_bottom_navigation.dart';
import 'package:yopp/modules/bottom_navigation/discover/ui/discover_screen.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/profile_screen.dart';
import 'package:yopp/modules/initial/service/push_notification_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/widgets/enable_location_widget.dart';

import 'discover/bloc/discover_location_bloc.dart';
import 'discover/bloc/discover_location_event.dart';
import 'discover/bloc/discover_location_state.dart';

final PushNotificationService _pushNotificationService =
    PushNotificationService();

Future handlePushNotificationStartUpLogic(BuildContext context) async {
  await _pushNotificationService.initialise(context);
}

class BottomNavigationScreen extends StatefulWidget {
  // static const routeName = "/nav";

  final UserProfile userProfile;

  BottomNavigationScreen({Key key, @required this.userProfile})
      : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  PageController pageController;

  String _uid;

  ProfileScreen _profileScreen;
  DiscoverScreen _discoverScreen;
  ChatListScreen _chatListScreen;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseCrashlytics.instance.setUserIdentifier(_uid);

    _profileScreen = ProfileScreen(
      userId: _uid,
      profile: widget.userProfile,
    );
    _discoverScreen = DiscoverScreen();
    _chatListScreen = ChatListScreen();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkLocationPermission(context);

      handlePushNotificationStartUpLogic(context);
    });
    pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("BottomNavScreen:" + state.toString());
    switch (state) {
      case AppLifecycleState.resumed:
        _checkLocationPermission(context);
        OnlineStatusDatabase.updateUserPresence(_uid, true);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        OnlineStatusDatabase.updateUserPresence(_uid, false);
        break;
      case AppLifecycleState.detached:
        OnlineStatusDatabase.updateUserPresence(_uid, false);
        break;
    }
  }

  @override
  void dispose() {
    print("dispose bottom nav");
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();

    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiscoverLocationBloc, DiscoverLocationState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              _profileScreen,
              state.permission == LocationPermissionStatus.allowed
                  ? _discoverScreen
                  : EnableLocationWidget(
                      remindLater: null,
                      permission: state.permission,
                      enablePermission: () => _updateLocation(context)),
              _chatListScreen,
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          bottomNavigationBar: CustomBottomNavigation(
            navigationItems: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, color: Colors.grey),
                activeIcon: Icon(Icons.person_outline, color: Colors.black),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.crop_square, color: Colors.grey),
                activeIcon: Icon(Icons.crop_square, color: Colors.black),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.line_weight, color: Colors.grey),
                activeIcon: Icon(Icons.line_weight, color: Colors.black),
                label: 'Chat',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
      listener: (context, state) async {
        print("DisoverLocationServiceStatus" + state.status.toString());
        print(state.message);

        switch (state.status) {
          case DisoverLocationServiceStatus.none:
            break;
          case DisoverLocationServiceStatus.checking:
            break;
          case DisoverLocationServiceStatus.saving:
            break;

          case DisoverLocationServiceStatus.saved:
            BlocProvider.of<ProfileBloc>(context).add(GetUserProfile());
            break;

          case DisoverLocationServiceStatus.failed:
            break;

          case DisoverLocationServiceStatus.locationChanged:
            break;

          case DisoverLocationServiceStatus.locatedInSameArea:
            break;

          case DisoverLocationServiceStatus.checkSuccess:
            print("check success:" + state.permission.toString());
            switch (state.permission) {
              case LocationPermissionStatus.denied:
                break;
              case LocationPermissionStatus.serviceDisabled:
                break;
              case LocationPermissionStatus.deniedForever:
                break;
              case LocationPermissionStatus.allowed:
                await _updateLocation(context);
                break;
            }
            break;
        }
      },
    );
  }

  _checkLocationPermission(BuildContext context) {
    BlocProvider.of<DiscoverLocationBloc>(context)
        .add(CheckLocationPermission());
  }

  Future<void> _updateLocation(BuildContext context) async {
    final profile = await SharedPreferenceService().getUserProfile();
    if (profile?.address == null) {
      BlocProvider.of<DiscoverLocationBloc>(context).add(UpdateLocationEvent());
    } else {
      BlocProvider.of<DiscoverLocationBloc>(context)
          .add(UpdateIfLocationChanged());
    }
  }
}
