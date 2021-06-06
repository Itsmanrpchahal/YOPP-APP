import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/base_view_model.dart';
import 'package:yopp/modules/authentication/change_number/bloc/change_number_bloc.dart';
import 'package:yopp/modules/authentication/change_number/bloc/change_number_state.dart';
import 'package:yopp/modules/authentication/change_number/change_phone_screen.dart';
import 'package:yopp/modules/authentication/otp/bloc/otp_bloc.dart';
import 'package:yopp/modules/authentication/otp/bloc/otp_event.dart';

import 'package:yopp/modules/authentication/otp/otp_form.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';

class OtpScreen extends StatefulWidget {
  static Route route(String countryCode, String number) {
    return FadeRoute(
      builder: (_) => OtpScreen(
        countryCode: countryCode,
        phoneNumber: number,
      ),
    );
  }

  final String countryCode;
  final String phoneNumber;

  const OtpScreen({
    Key key,
    this.countryCode,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState(countryCode, phoneNumber);
}

class _OtpScreenState extends State<OtpScreen> {
  String countryCode;
  String phoneNumber;

  _OtpScreenState(this.countryCode, this.phoneNumber);

  @override
  void initState() {
    countryCode = widget.countryCode;
    phoneNumber = widget.phoneNumber;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _sendOtp(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      appBar: TransparentAppBar(
        context: context,
        titleText: "Confirm Number",
        showBackButton: Navigator.of(context).canPop(),
      ),
      body: BlocListener<ChangeNumberBloc, ChangeNumberState>(
        listener: (context, state) {
          switch (state.status) {
            case ServiceStatus.none:
              break;
            case ServiceStatus.loading:
              break;
            case ServiceStatus.success:
              setState(() {
                phoneNumber = state.phoneNumber;
                countryCode = state.countryCode;
              });
              _sendOtp(context);

              break;
            case ServiceStatus.failure:
              break;
          }
        },
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            _buildIcon(context),
            SizedBox(height: 24),
            Text(
              "We sent a code",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
                "Enter the 6 digit OTP code  sent to your number.\n" +
                    countryCode +
                    " " +
                    phoneNumber,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white70)),
            SizedBox(height: 12),
            Container(color: AppColors.orange, height: 2, width: 26),
            SizedBox(height: 32),
            OtpForm(),
            FlatButton.icon(
                textColor: Colors.white70,
                onPressed: () => _sendOtp(context),
                icon: Icon(Icons.refresh),
                label: Text("Resend")),
            FlatButton(
              onPressed: () {
                _changePhoneNumber(context);
              },
              child: Text("Change Phone Number.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  )),
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

  void _sendOtp(BuildContext context) {
    BlocProvider.of<OtpBloc>(context, listen: false)
        .add(SendOtpEvent(countryCode, phoneNumber));
  }

  void _changePhoneNumber(BuildContext context) async {
    await Navigator.of(context)
        .push(ChangePhoneNumberScreen.route(countryCode, phoneNumber));
  }
}
