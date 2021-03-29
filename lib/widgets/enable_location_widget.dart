import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/models/location_permission_status.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/buttons/rounded_button.dart';

class EnableLocationWidget extends StatelessWidget {
  final Function remindLater;
  final Function enablePermission;

  final LocationPermissionStatus permission;

  const EnableLocationWidget({
    Key key,
    @required this.remindLater,
    @required this.permission,
    @required this.enablePermission,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
        appBar: TransparentAppBar(
          context: context,
          titleText: "Where do you live",
          showBackButton: Navigator.of(context).canPop(),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildIcon(context),
                SizedBox(height: 40),
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
                    "Your location service needs to be turned on in order to find suitable practise partners nearby.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white70)),
                SizedBox(height: 12),
                Center(
                    child: Container(
                        color: AppColors.orange, height: 2, width: 26)),
                SizedBox(height: 32),
                permission == LocationPermissionStatus.denied ||
                        permission == LocationPermissionStatus.allowed
                    ? RoundedButton(
                        titleText: "Enable Location",
                        onPressed: enablePermission,
                      )
                    : Container(),
                permission == LocationPermissionStatus.serviceDisabled ||
                        permission == LocationPermissionStatus.deniedForever
                    ? RoundedButton(
                        titleText: "Open Settings",
                        onPressed: () => _openSettings(context))
                    : Container(),
                SizedBox(height: 24),
                remindLater == null
                    ? Container()
                    : FlatButton(
                        onPressed: remindLater,
                        child: Text("Remind me later",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white70)
                                .copyWith(
                                    decoration: TextDecoration.underline))),
              ],
            )),
          ),
        ));
  }

  _buildIcon(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconWidth = min(size.height, size.width) / 4;
    return CircleAvatar(
      radius: iconWidth / 2,
      backgroundColor: Colors.white24,
      child: Icon(
        Icons.smartphone,
        color: Colors.white,
        size: iconWidth / 2,
      ),
    );
  }

  _openSettings(BuildContext context) async {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    if (isIOS) {
      await Geolocator.openLocationSettings();
    }
    if (isAndroid) {
      permission == LocationPermissionStatus.serviceDisabled
          ? await Geolocator.openLocationSettings()
          : await Geolocator.openAppSettings();
    }
  }
}
