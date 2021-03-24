import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/authentication/forget_password/forget_password_form.dart';

import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import 'bloc/forget_bloc.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static const String routeName = '/forget_password';
  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      appBar: TransparentAppBar(
        context: context,
        titleText: "Forgot Password",
      ),
      body: ProgressHud(
        child: BlocListener<ForgotBloc, BaseState>(
          child: _buildBody(context),
          listener: (context, state) async {
            ProgressHud.of(context).dismiss();
            switch (state.status) {
              case ServiceStatus.initial:
                break;

              case ServiceStatus.loading:
                ProgressHud.of(context)
                    .show(ProgressHudType.loading, state.message);
                break;

              case ServiceStatus.success:
                ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.success, state.message)
                    .then((value) {
                  Navigator.of(context).pop();
                });
                break;

              case ServiceStatus.failure:
                await ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.error, state.message);
                break;
            }
          },
        ),
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
              "Forgot Password?",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text("Enter the email address associated with your account",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white70)),
            SizedBox(height: 12),
            Container(color: AppColors.orange, height: 2, width: 26),
            SizedBox(height: 32),
            ForgetPasswordForm(),
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
      child: Icon(
        Icons.smartphone,
        color: Colors.white,
        size: iconWidth / 2,
      ),
    );
  }
}
