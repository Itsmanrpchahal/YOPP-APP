import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_bloc.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_event.dart';
import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/privacy_policy_screen.dart';
import 'package:yopp/modules/screens.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
  
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String platformVersion = await FlutterSimCountryCode.simCountryCode;
      print("platformVersion:" + platformVersion ?? "");

      BlocProvider.of<RegisterBloc>(context, listen: false)
          .add(GotCountryNameEvent(countryName: platformVersion));
    } on PlatformException catch (exception) {
      print('Failed to get platform version.');
      FirebaseCrashlytics.instance.log('AuthScreen initPlatformState');
      FirebaseCrashlytics.instance.log('Failed to get platform version.');
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: exception));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildLogoSection(context)),
          Expanded(child: _buildAuthSection(context)),
        ],
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    final length = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Column(
      children: [
        Spacer(),
        Container(
          child: Image.asset(
            "assets/icons/white_app_logo.png",
            width: length * 0.7,
          ),
        ),
        Text(
          '~Your Practise Partner~',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
        )
      ],
    );
  }

  Widget _buildAuthSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Spacer(flex: 2),
        Container(
          width: width * 0.75,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLoginSection(context),
              Center(
                  child:
                      Container(height: 48, width: 2, color: AppColors.orange)),
              _buildSignUpSection(context),
            ],
          ),
        ),
        Spacer(),
        _buildPolicySection(context),
        Spacer(),
      ],
    );
  }

  _buildPolicySection(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: AppColors.darkGrey),
          children: [
            TextSpan(
              text:
                  "By using YOPP you agree with our Terms Of Use.\nLearn how we protect your Privacy In our",
            ),
            TextSpan(
              text: "\nPrivacy Policy",
              style: TextStyle(decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _showPrivacyPlolicy(context),
            ),
          ],
        ));
  }

  Widget _buildLoginSection(BuildContext context) {
    return Column(
      children: [
        IconButton(
            iconSize: 66,
            icon: CircleAvatar(
              radius: 66,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "assets/icons/key.svg",
              ),
            ),
            onPressed: () => _showLoginScreen(context)),
        Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }

  Widget _buildSignUpSection(BuildContext context) {
    return Column(
      children: [
        IconButton(
            iconSize: 66,
            icon: CircleAvatar(
              radius: 66,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "assets/icons/add_person.svg",
                color: AppColors.orange,
              ),
            ),
            onPressed: () => _showRegisterScreen(context)),
        Text(
          "Sign up",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }

  _showPrivacyPlolicy(BuildContext context) async {
    Navigator.of(context).push(PrivacyPolicyScreen.route);
  }

  _showLoginScreen(BuildContext context) {
    Navigator.of(context).push(LoginScreen.route);
  }

  _showRegisterScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
  }
}
