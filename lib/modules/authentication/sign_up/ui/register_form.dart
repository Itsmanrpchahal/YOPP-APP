import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/helper/validator.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_bloc.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_event.dart';
import 'package:yopp/modules/authentication/sign_up/ui/country_picker.dart';
import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/terms_of_use_screen.dart';
import 'package:yopp/widgets/snackbar/custom_snackbar.dart';
import 'package:yopp/widgets/textfield/auth_field.dart';

class RegisterForm extends StatefulWidget {
  final String countryCode;

  const RegisterForm({Key key, this.countryCode}) : super(key: key);
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _fullNameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _phoneController;
  String _countryCode;
  var phoneIsValid = true;

  bool agreeTerms = false;

  @override
  void initState() {
    _countryCode = widget.countryCode;

    _setUpForm();

    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  _setUpForm() {
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                "Register",
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
                    controller: _fullNameController,
                    placeHolderText: "Full name",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return value.isNotEmpty
                          ? null
                          : "Please, Enter the valid FullName.";
                    },
                  )),
              SizedBox(height: 15),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AuthField(
                    controller: _passwordController,
                    placeHolderText: "Password",
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return Validator.isValidPassword(value)
                          ? null
                          : "Please, Enter the valid Password.";
                    },
                  )),
              SizedBox(height: 15),
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
              _buildPhoneNumberSection(context),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        iconSize: 27,
                        icon: CircleAvatar(
                          backgroundColor: agreeTerms
                              ? Colors.white
                              : Colors.white.withOpacity(0.25),
                          child: agreeTerms
                              ? Icon(
                                  Icons.check,
                                  color: AppColors.orange,
                                )
                              : Container(),
                        ),
                        onPressed: () {
                          setState(() {
                            agreeTerms = !agreeTerms;
                          });
                        }),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "Agree to ",
                            ),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _showTermsAndCondition(context),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              SizedBox(height: 32),
              FlatButton.icon(
                color: Colors.white,
                height: 62,
                onPressed: () {
                  _register(context);
                },
                icon: Icon(Icons.check),
                label: Container(),
              )
            ],
          )),
    );
  }

  _buildPhoneNumberSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CountryPicker(
            onChanged: (code) {
              _countryCode = code.dialCode;
            },
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: AuthField(
              controller: _phoneController,
              placeHolderText: "Phone",
              keyboardType: TextInputType.phone,
              validator: (value) {
                return phoneIsValid ? null : "Please Enter valid Number.";
              },
            ),
          ),
        ],
      ),
    );
  }

  _register(BuildContext context) async {
    if (agreeTerms == false) {
      CustomSnackbar.showFailed(
          context, "Please Accept Terms and Conditions first.");
      return;
    }

    try {
      await FlutterLibphonenumber().parse(_countryCode + _phoneController.text);

      phoneIsValid = true;

      if (_formkey.currentState.validate()) {
        BlocProvider.of<RegisterBloc>(context).add(RegisterEvent(
          name: _fullNameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          password: _passwordController.text,
          countryCode: _countryCode,
        ));
      }
    } catch (e) {
      setState(() {
        phoneIsValid = false;
      });
    }
  }

  _showTermsAndCondition(BuildContext context) {
    Navigator.of(context).push(TermsofUseScreen.route);
  }
}
