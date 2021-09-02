import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/base_view_model.dart';
import 'package:yopp/modules/authentication/change_number/from.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import 'bloc/change_number_bloc.dart';
import 'bloc/change_number_state.dart';

class ChangePhoneNumberScreen extends StatefulWidget {
  static Route route(String countryCode, String number) {
    return FadeRoute(
        builder: (_) => ChangePhoneNumberScreen(
              countryCode: countryCode,
              phoneNumber: number,
            ));
  }

  final String countryCode;
  final String phoneNumber;

  const ChangePhoneNumberScreen({
    Key key,
    this.countryCode,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _ChangePhoneNumberScreenState createState() =>
      _ChangePhoneNumberScreenState(countryCode, phoneNumber);
}

class _ChangePhoneNumberScreenState extends State<ChangePhoneNumberScreen> {
  String countryCode;
  String phoneNumber;

  _ChangePhoneNumberScreenState(this.countryCode, this.phoneNumber);

  @override
  void initState() {
    countryCode = widget.countryCode;
    phoneNumber = widget.phoneNumber;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
        appBar: TransparentAppBar(
          context: context,
          titleText: "Update Number",
          showBackButton: Navigator.of(context).canPop(),
        ),
        body: BlocListener<ChangeNumberBloc, ChangeNumberState>(
          listener: (context, state) async {
            ProgressHud.of(context).dismiss();
            switch (state.status) {
              case ServiceStatus.none:
                break;
              case ServiceStatus.loading:
                ProgressHud.of(context)
                    .show(ProgressHudType.progress, state.message);
                break;
              case ServiceStatus.success:
                Navigator.of(context).pop();

                break;
              case ServiceStatus.failure:
                await ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.error, state.message);
                break;
            }
          },
          child: _buildBody(context),
        ));
  }

  _buildBody(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            _buildIcon(context),
            SizedBox(height: 16),
            Text(
              "Update Number",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text("Enter the your Phone Number.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white70)),
            SizedBox(height: 12),
            Container(color: AppColors.orange, height: 2, width: 26),
            SizedBox(height: 32),
            NumberForm(
              phoneNumber: phoneNumber,
              countryCode: countryCode,
            ),
          ],
        )),
      ),
    );
  }

  _buildIcon(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconWidth = min(size.height, size.width) / 4;
    return CircleAvatar(
        radius: iconWidth / 2,
        backgroundColor: Colors.white24,
        child: Image.asset(
          'assets/icons/phone2.png',
          width: iconWidth / 4,
          fit: BoxFit.scaleDown,
          color: Colors.white,
        ));
  }
}
