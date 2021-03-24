import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/helper/validator.dart';
import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
import 'package:yopp/modules/authentication/bloc/authentication_event.dart';
import 'package:yopp/modules/authentication/login/bloc/login_bloc.dart';
import 'package:yopp/modules/authentication/login/bloc/login_event.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/screens.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';
import 'package:yopp/widgets/textfield/auth_field.dart';

import 'bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");
  bool rememberPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        ProgressHud.of(context).dismiss();
        print(state);
        switch (state.status) {
          case LoginStatus.inital:
            setState(() {
              _emailController.text = state.email;
              _passwordController.text = state.password;
              rememberPassword = state.rememberMe;
            });
            break;
          case LoginStatus.loading:
            ProgressHud.of(context)
                .show(ProgressHudType.loading, state.message);

            break;
          case LoginStatus.success:
            _showMainScreen(context, state.userProfile);

            break;
          case LoginStatus.faliure:
            ProgressHud.of(context)
                .showAndDismiss(ProgressHudType.error, state.message);

            break;
          case LoginStatus.optPending:
            Navigator.of(context).push(OtpScreen.route(
                state.userProfile.countryCode, state.userProfile.phone));
            break;
          case LoginStatus.genderPending:
            Navigator.of(context).pushNamed(GenderSelectScreen.routeName);
            break;

          case LoginStatus.birthYearPending:
            Navigator.of(context).pushNamed(SelectYearScreen.routeName);
            break;
          case LoginStatus.abilityPending:
            Navigator.of(context).push(SelectActivityScreen.route(
                isInitialSetupScreen: SelectAbilityEnum.initialSetup));
            break;
          case LoginStatus.profilePending:
            Navigator.of(context)
                .push(EditProfileScreen.route(state.userProfile, true));
            break;
        }
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(62),
            bottomLeft: Radius.circular(62),
          ),
        ),
        child: Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: 40),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AuthField(
                      controller: _emailController,
                      placeHolderText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        return Validator.isEmail(value)
                            ? null
                            : "Please, Enter the valid Email.";
                      },
                    )),
                SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AuthField(
                      controller: _passwordController,
                      obscureText: true,
                      placeHolderText: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        return Validator.isValidPassword(value)
                            ? null
                            : "Please, Enter the valid password.";
                      },
                    )),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 27,
                          icon: CircleAvatar(
                            backgroundColor: rememberPassword
                                ? Colors.white
                                : Colors.white.withOpacity(0.25),
                            child: rememberPassword
                                ? Icon(
                                    Icons.check,
                                    color: AppColors.orange,
                                  )
                                : Container(),
                          ),
                          onPressed: () {
                            setState(() {
                              rememberPassword = !rememberPassword;
                            });
                          }),
                      Text(
                        "Remember Me?",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 32),
                FlatButton.icon(
                  color: Colors.white,
                  height: 62,
                  onPressed: () => loginAction(context),
                  icon: Icon(Icons.check),
                  label: Container(),
                )
              ],
            )),
      ),
    );
  }

  loginAction(BuildContext context) {
    if (_formkey.currentState.validate()) {
      BlocProvider.of<LoginBloc>(context).add(LoginInitiateEvent(
          _emailController.text, _passwordController.text, rememberPassword));
    }
  }

  _showMainScreen(BuildContext context, UserProfile userProfile) {
    BlocProvider.of<AuthBloc>(context)
        .add(SuccessfullyLogedInEvent(userProfile: userProfile));
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
