import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/authentication/bloc/authentication_service.dart';
import 'package:yopp/modules/authentication/login/login_form.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/api_service.dart';
import 'package:yopp/modules/screens.dart';
import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';

class LoginScreen extends StatelessWidget {
  static get route {
    return FadeRoute(builder: (context) {
      return BlocProvider<LoginBloc>(
        create: (BuildContext context) => LoginBloc(
          AuthService(),
          APIProfileService(),
        )..add(LoginInitialEvent()),
        child: LoginScreen(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoginBloc>(context, listen: false).add(LoginInitialEvent());
    return FullGradientScaffold(
      appBar: _buildAppBar(context),
      body: ProgressHud(
        child: _buildBody(context),
      ),
    );

  }

  Widget _buildBody(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildLoginIcon(context),
          SizedBox(height: 24),
          LoginForm(),
          _buildFooter(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return TransparentAppBar(
      context: context,
      titleText: "Login",
    );
  }

  _buildLoginIcon(BuildContext context) {
    final diameter = MediaQuery.of(context).size.width / 5;
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: AppColors.darkGrey.withOpacity(0.3),
              spreadRadius: 35,
              blurRadius: 40),
        ],
      ),
      child: SvgPicture.asset(
        'assets/icons/key.svg',
        fit: BoxFit.scaleDown,
      ),
    );
  }

  Widget _buildForgetPasswordButton(BuildContext context) {
    return TextButton(
        onPressed: () => _showForgetPasswordScreen(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/icons/key.svg",
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Text("Forgot Password?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ],
        ));
  }

  Widget _buildSignUpButton(BuildContext context) {
    return TextButton(
        onPressed: () => _showRegisterScreen(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/icons/add_person.svg",
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Text("Sign up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ],
        ));
  }

  _buildFooter(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
        ),
        _buildForgetPasswordButton(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: Colors.deepPurple,
          ),
        ),
        _buildSignUpButton(context),
      ],
    );
  }

  _showRegisterScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
  }

  _showForgetPasswordScreen(BuildContext context) {
    Navigator.of(context).pushNamed(ForgetPasswordScreen.routeName);
  }
}
