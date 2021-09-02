import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:yopp/helper/url_constants.dart';

import 'package:yopp/modules/_common/models/database.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/_common/models/location_permission_status.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_state.dart';

import 'package:yopp/modules/bottom_navigation/custom_bottom_navigation.dart';
import 'package:yopp/modules/bottom_navigation/discover/ui/discover_screen.dart';
import 'package:yopp/modules/bottom_navigation/drawer/drawer.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/about/welcome_dialog.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_state.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connections_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/profile_screen.dart';
import 'package:yopp/modules/initial/service/push_notification_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/widgets/enable_location_widget.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import 'bloc/bottom_nav_bloc.dart';

import 'chat/chat_detail/ui/chat_detail_screen.dart';
import 'discover/bloc/discover_location_bloc.dart';
import 'discover/bloc/discover_location_event.dart';
import 'discover/bloc/discover_location_state.dart';
import 'profile/bloc/profile_bloc.dart';
import 'profile/bloc/profile_event.dart';

final PushNotificationService _pushNotificationService =
    PushNotificationService();

Future handlePushNotificationStartUpLogic(BuildContext context) async {
  await _pushNotificationService.initialise(context);
}

class BottomNavigationScreen extends StatefulWidget {
  final UserProfile userProfile;
  final List<InterestOption> interests;

  BottomNavigationScreen(
      {Key key, @required this.userProfile, @required this.interests})
      : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _selectedIndex = 0;
  PageController pageController;

  ProfileScreen _profileScreen;
  DiscoverScreen _discoverScreen;

  TabController profileTabController;
  IO.Socket socket;

  bool updateIfLocationChanged;

  void updateOnlineStatus(String uid) {
    // print("connect:" + uid);

    socket?.dispose();

    socket = IO.io(
      UrlConstants.baseUrl,
      OptionBuilder()
          .setTransports(
            ['websocket'],
          )
          .enableForceNew()
          .setExtraHeaders(
            {'uid': uid},
          )
          .setQuery(
            {'uid': uid},
          )
          .build(),
    );

    socket.connect();
    socket.on('event', (data) => print('connect' + data?.toString() ?? ""));

    socket.onConnect((data) {
      print('socket.onConnect');
    });

    socket.onDisconnect((data) {
      print("socket.onDisconnect");
    });

    socket.onConnectError((data) {
      print("socket.onConnectError");
    });

    socket.onError((data) {
      print("socket.onError");
    });
  }

  @override
  void initState() {
    super.initState();
    print("BottomNavigationScreen");
    print("View 1 =>    "+widget.userProfile.toString());
    print("View 2 =>    "+widget.interests.toString());

    updateIfLocationChanged = true;

    context.read<ProfileBloc>().add(SetUserProfileEvent(
        profile: widget.userProfile,
        interests: widget.interests,
        connectionCount: widget.userProfile?.connection?.length ?? 0));

    profileTabController =
        TabController(length: 3, initialIndex: 0, vsync: this);

    _profileScreen = ProfileScreen(
      userId: FirebaseAuth.instance.currentUser.uid,
      profileTabController: profileTabController,
    );

    _discoverScreen = DiscoverScreen();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateOnlineStatus(FirebaseAuth.instance.currentUser.uid);
      _checkLocationPermission(context);

      handlePushNotificationStartUpLogic(context);
      OnlineStatusDatabase.updateUserPresence(
          FirebaseAuth.instance.currentUser.uid, true);

      if (widget.userProfile.selectedInterest == null) {
        print("WelcomeDialog ");

        WelcomeDialog.show(context);
      } else {
        print("Not WelcomeDialog ");
      }
    });
    pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // print("BottomNavScreen:" + state.toString());
    switch (state) {
      case AppLifecycleState.resumed:
        _checkLocationPermission(context);
        if (socket.disconnected) {
          socket.connect();
        }
        OnlineStatusDatabase.updateUserPresence(
            FirebaseAuth.instance.currentUser.uid, true);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        if (socket.connected) {
          socket.disconnect();
        }
        OnlineStatusDatabase.updateUserPresence(
            FirebaseAuth.instance.currentUser.uid, false);
        break;
      case AppLifecycleState.detached:
        if (socket.connected) {
          socket.disconnect();
        }
        OnlineStatusDatabase.updateUserPresence(
            FirebaseAuth.instance.currentUser.uid, false);
        break;
    }
  }

  @override
  void dispose() {
    print("dispose bottom nav screen");
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();

    socket.io.cleanup();
    socket.dispose();

    super.dispose();
  }

  void _onItemTapped({@required int index, int tab = -1}) {
    if (index == 0) {
      pageController.jumpToPage(0);

      setState(() {
        _selectedIndex = index;
        if (tab != null && tab != -1) {
          _profileScreen.profileTabController.index = tab;
        }
       
      });
    }

    if (index == 1) {
      pageController.jumpToPage(index);
      setState(() {
        _selectedIndex = index;
      });
    }

    if (index == 2) {
      pageController.jumpToPage(0);
      setState(() {
        _selectedIndex = 2;
        _profileScreen.profileTabController.index = 2;
        // onPageChanged(2);
      });
    }
  }

  void onPageChanged(int index) {
    print("onPageChanged" + index.toString());
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: BlocConsumer<DiscoverLocationBloc, DiscoverLocationState>(
        builder: (context, state) {
          return MultiBlocListener(
            listeners: [
              BlocListener<ConnectionsBloc, ConnectionsState>(
                listener: (context, state) async {
                  print("bottomNav:");
                  print(state.serviceStatus);
                  ProgressHud.of(context).dismiss();
                  switch (state.serviceStatus) {
                    case ConnectionServiceStatus.initial:
                      break;

                    case ConnectionServiceStatus.creatingConnection:
                      ProgressHud.of(context).showLoading(text: state.message);
                      break;

                    case ConnectionServiceStatus.readyForChat:
                      print("bottomNav: readyForChat");
                      Navigator.of(context).push(ChatDetailScreen.route(
                        chatDescription: state.chatRoomCreated,
                        chatRoomId: state.chatRoomCreated.chatRoomId,
                      ));
                      print("bottomNav: backFromChat");
                      break;

                    case ConnectionServiceStatus.connectionFailed:
                      await ProgressHud.of(context)
                          .showErrorAndDismiss(text: state.message);
                      break;

                    case ConnectionServiceStatus.loading:
                      ProgressHud.of(context).showLoading(text: state.message);
                      break;

                    case ConnectionServiceStatus.loaded:
                      if (state.userConnection?.total != null) {
                        context.read<ProfileBloc>().add(
                              SetUserProfileEvent(
                                  connectionCount: state.userConnection.total),
                            );
                      }
                      break;

                    case ConnectionServiceStatus.loadingFailed:
                      await ProgressHud.of(context)
                          .showErrorAndDismiss(text: state.message);
                      break;

                    case ConnectionServiceStatus.loadingMore:
                      break;

                    case ConnectionServiceStatus.loadedMore:
                      if (state.userConnection?.total != null) {
                        context.read<ProfileBloc>().add(
                              SetUserProfileEvent(
                                  connectionCount: state.userConnection.total),
                            );
                      }
                      break;

                    case ConnectionServiceStatus.loadingMoreFailed:
                      break;

                    case ConnectionServiceStatus.deleting:
                      ProgressHud.of(context).showLoading(text: state.message);
                      break;

                    case ConnectionServiceStatus.deleted:
                      context
                          .read<ConnectionsBloc>()
                          .add(LoadConnectionEvent());
                      break;

                    case ConnectionServiceStatus.deletingFailed:
                      await ProgressHud.of(context)
                          .showErrorAndDismiss(text: state.message);
                      break;
                  }
                },
              ),
              BlocListener<BottomNavBloc, BottomNavState>(
                  listener: (context, state) {
                switch (state.selectedOption) {
                  case BottomNavOption.profile:
                    _onItemTapped(
                      index: state.selectedOption.index,
                      tab: state?.tabOption?.index,
                    );

                    break;
                  case BottomNavOption.discover:
                    if (state.selectedOption.index != _selectedIndex) {
                      _onItemTapped(index: state.selectedOption.index);
                    }
                    break;
                  case BottomNavOption.connections:
                    _onItemTapped(
                      index: BottomNavOption.connections.index,
                      tab: TabBarOption.third.index,
                    );

                    break;
                }
              })
            ],
            child: Scaffold(
              drawer: buildDrawer(context),
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
                          enablePermission: () => _updateLocation(context),
                        ),
                  Material(),
                ],
                controller: pageController,
                onPageChanged: onPageChanged,
              ),
              bottomNavigationBar: CustomBottomNavigation(
                  navigationItems: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline, color: Colors.grey),
                      activeIcon:
                          Icon(Icons.person_outline, color: Colors.black),
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
                      label: 'Connections',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTap: (index) {
                    if (index == 0) {
                      _onItemTapped(index: 0, tab: 0);
                    }

                    if (index == 1) {
                      _onItemTapped(index: 1);
                    }

                    if (index == 2) {
                      _onItemTapped(
                        index: 2,
                      );
                    }
                  }),
            ),
          );
        },
        listener: (context, state) async {
          print("DisoverLocationServiceStatus: " + state.status.toString());
          print("DisoverLocationServiceStatus Message: " + state.message);

          ProgressHud.of(context).dismiss();
          switch (state.status) {
            case DisoverLocationServiceStatus.none:
              break;
            case DisoverLocationServiceStatus.checking:
              ProgressHud.of(context)
                  .showLoading(text: "Syncronizing profile.");

              break;

            case DisoverLocationServiceStatus.saving:
              ProgressHud.of(context)
                  .showLoading(text: "Syncronizing profile.");
              break;

            case DisoverLocationServiceStatus.saved:
              if (state.userProfile != null) {
                print("DisoverLocationServiceStatus" +
                    state.userProfile.location.toRawJson());

                context.read<ProfileBloc>().add(SetUserProfileEvent(
                      profile: state.userProfile,
                      connectionCount:
                          state.userProfile?.connection?.length ?? 0,
                    ));

                print("DisoverLocationServiceStatus" +
                    context
                        .read<ProfileBloc>()
                        .state
                        .userProfile
                        .location
                        .toRawJson());
                print("DisoverLocationServiceStatus Saved");
                updateIfLocationChanged = false;
              }

              await ProgressHud.of(context)
                  .showSuccessAndDismiss(text: "Profile Syncronized.");
              break;

            case DisoverLocationServiceStatus.failed:
              break;

            case DisoverLocationServiceStatus.locationChanged:
              break;

            case DisoverLocationServiceStatus.locatedInSameArea:
              updateIfLocationChanged = false;
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
                  _updateLocation(context);
                  break;
              }
              break;
          }
        },
      ),
    );
  }

  _checkLocationPermission(BuildContext context) {
    BlocProvider.of<DiscoverLocationBloc>(context, listen: false)
        .add(CheckLocationPermission());
  }

  Future<void> _updateLocation(BuildContext context) async {
    final updatedUserProfile =
        context.read<DiscoverLocationBloc>().state.userProfile ??
            widget.userProfile;
    if (updatedUserProfile?.location == null) {
      print("DisoverLocationServiceStatus Message: UpdateLocationEvent");
      BlocProvider.of<DiscoverLocationBloc>(context, listen: false)
          .add(UpdateLocationEvent());
    } else {
      print("DisoverLocationServiceStatus Message: UpdateIfLocationChanged");
      BlocProvider.of<DiscoverLocationBloc>(context, listen: false)
          .add(UpdateIfLocationChanged(updatedUserProfile.location));
      //TODO:- Use this to not check the location again once checked.
      // if (updateIfLocationChanged) {
      //   print("DisoverLocationServiceStatus Message: UpdateIfLocationChanged");
      //   BlocProvider.of<DiscoverLocationBloc>(context, listen: false)
      //       .add(UpdateIfLocationChanged(updatedUserProfile.location));
      // }
    }
  }
}
