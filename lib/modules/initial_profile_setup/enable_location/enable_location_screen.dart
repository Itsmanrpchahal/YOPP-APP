import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/firebase_profile_service.dart';

import 'package:yopp/modules/initial_profile_setup/enable_location/bloc/location_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/enable_location/bloc/location_event.dart';

import 'package:yopp/modules/initial_profile_setup/enable_location/bloc/location_state.dart';
import 'package:yopp/modules/screens.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import '../../../widgets/enable_location_widget.dart';

class EnableLocationScreen extends StatefulWidget {
  static Route route() {
    return FadeRoute(
        builder: (_) => BlocProvider<LocationBloc>(
              create: (BuildContext context) =>
                  LocationBloc(FirebaseProfileService()),
              child: EnableLocationScreen(),
            ));
  }

  const EnableLocationScreen({
    key,
  }) : super(key: key);

  @override
  _EnableLocationScreenState createState() => _EnableLocationScreenState();
}

class _EnableLocationScreenState extends State<EnableLocationScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    print("init EnableLocation ");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<LocationBloc>(context).add(CheckLocationPermission());
    });

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          BlocProvider.of<LocationBloc>(context).add(CheckLocationPermission());
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    print("dispose EnableLocation ");
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: BlocConsumer<LocationBloc, LocationState>(
        builder: (context, state) => EnableLocationWidget(
          permission: state.permission,
          remindLater: () => _showNextScreen(context),
          enablePermission: () =>
              BlocProvider.of<LocationBloc>(context).add(SaveLocationEvent()),
        ),
        listener: (context, state) async {
          ProgressHud.of(context).dismiss();
          switch (state.status) {
            case LocationServiceStatus.none:
              break;
            case LocationServiceStatus.checking:
              break;

            case LocationServiceStatus.failed:
              await ProgressHud.of(context)
                  .showAndDismiss(ProgressHudType.error, state.message);
              break;

            case LocationServiceStatus.saving:
              ProgressHud.of(context)
                  .show(ProgressHudType.loading, state.message);
              break;

            case LocationServiceStatus.saved:
              _showNextScreen(context);
              break;

            case LocationServiceStatus.checkSuccess:
              break;
          }
        },
      ),
    );
  }

  _showNextScreen(BuildContext context) async {
    Navigator.of(context).pushNamed(SelectYearScreen.routeName);
  }
}
