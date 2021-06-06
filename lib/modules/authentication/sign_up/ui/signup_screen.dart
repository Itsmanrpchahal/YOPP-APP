import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/authentication/otp/otp_screen.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_bloc.dart';

import 'package:yopp/modules/authentication/sign_up/bloc/register_state.dart';
import 'package:yopp/modules/authentication/sign_up/ui/register_form.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = 'register';

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      appBar: _buildAppBar(context),
      body: ProgressHud(
        child: BlocConsumer<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return _buildBody(context, state.countryCode);
          },
          listener: (context, state) async {
            ProgressHud.of(context).dismiss();
            // print(state.status);
            switch (state.status) {
              case RegisterStatus.inital:
                break;
              case RegisterStatus.loading:
                ProgressHud.of(context)
                    .show(ProgressHudType.loading, state.message);
                break;
              case RegisterStatus.countryDialCodeLoaded:
                break;
              case RegisterStatus.success:
                await ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.success, state.message);
                _showConfirmOTPScreen(
                  context,
                  state.countryCode,
                  state.phoneNumber,
                );
                break;
              case RegisterStatus.faliure:
                await ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.error, state.message);
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, String countryCode) {
    return Align(
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildRegisterIcon(context),
          SizedBox(height: 24),
          RegisterForm(
            countryCode: countryCode,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return TransparentAppBar(context: context, titleText: "Register");
  }

  _buildRegisterIcon(BuildContext context) {
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
        "assets/icons/add_person.svg",
        color: AppColors.orange,
        fit: BoxFit.scaleDown,
      ),
    );
  }

  _showConfirmOTPScreen(
      BuildContext context, String countryCode, String number) {
    Navigator.of(context).push(OtpScreen.route(countryCode, number));
  }
}
