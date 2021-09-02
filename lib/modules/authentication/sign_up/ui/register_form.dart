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
  String phoneNumberError;

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
      padding: EdgeInsets.all(20),
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
              AuthField(
                controller: _fullNameController,
                textCapitalization: TextCapitalization.words,
                placeHolderText: "Full name",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return value.isNotEmpty
                      ? null
                      : "Please, Enter your full Name.";
                },
              ),
              SizedBox(height: 15),
              PasswordField(passwordController: _passwordController),
              SizedBox(height: 15),
              AuthField(
                controller: _emailController,
                placeHolderText: "Email",
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return Validator.isEmail(value)
                      ? null
                      : "Please, Enter the valid Email.";
                },
              ),
              SizedBox(height: 15),
              _buildPhoneNumberSection(context),
              SizedBox(height: 15),
              Row(
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
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _showTermsAndCondition(context),
                          ),
                        ],
                      ))
                ],
              ),
              SizedBox(height: 15),
              FlatButton(
                color: AppColors.green,
                height: 50,
                onPressed: () {
                  _register(context);
                },
                child: Text(
                  "REGISTER",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          )),
    );
  }

  _buildPhoneNumberSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountryPicker(
          onChanged: (code) {
            _countryCode = code.dialCode;
            checkPhoneNumberError();
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
            validator: (value) => phoneNumberError,
            onChanged: (value) => checkPhoneNumberError(),
          ),
        ),
      ],
    );
  }

  Future<void> checkPhoneNumberError() async {
    try {
      await FlutterLibphonenumber().parse(_countryCode + _phoneController.text);
      // print(parsed);
      phoneNumberError = null;
    } catch (error) {
      if (_phoneController.text.isEmpty) {
        phoneNumberError = "Enter Phone Number.";
      } else {
        phoneNumberError = "Enter valid Phone Number.";
      }
    }
  }

  _register(BuildContext context) async {
    if (agreeTerms == false) {
      CustomSnackbar.showFailed(
          context, "Please Accept Terms and Conditions first.");
      return;
    }

    if (_formkey.currentState.validate() && phoneNumberError == null) {
      // print("validated");
      BlocProvider.of<RegisterBloc>(context, listen: false).add(RegisterEvent(
        name: _fullNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
        countryCode: _countryCode,
      ));
    }
  }

  _showTermsAndCondition(BuildContext context) {
    Navigator.of(context).push(TermsofUseScreen.route);
  }
}
