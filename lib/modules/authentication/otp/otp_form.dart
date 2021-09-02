import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/authentication/otp/bloc/otp_bloc.dart';
import 'package:yopp/modules/authentication/otp/bloc/otp_event.dart';
import 'package:yopp/modules/authentication/otp/bloc/otp_state.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/gender_select_screen.dart';

import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class OtpForm extends StatefulWidget {
  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) async {
        ProgressHud.of(context).dismiss();
        switch (state.status) {
          case OtpStatus.initial:
            break;
          case OtpStatus.sending:
            ProgressHud.of(context)
                .show(ProgressHudType.progress, state.message);
            break;
          case OtpStatus.sent:
            await ProgressHud.of(context)
                .showAndDismiss(ProgressHudType.success, state.message);
            break;
          case OtpStatus.faliure:
            textEditingController?.clear();
            await ProgressHud.of(context)
                .showAndDismiss(ProgressHudType.error, state.message);
            break;
          case OtpStatus.enteredCorrectOtp:
            _showGenderSelectScreen(context);
            break;
        }
      },
      child: Form(
          key: _formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PinCodeTextField(
                appContext: context,
                errorTextSpace: 30,
                pastedTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                length: 6,
                obscureText: false,
                obscuringCharacter: '*',
                animationType: AnimationType.fade,
                validator: (code) {
                  return (code.length == 6)
                      ? null
                      : "Enter 6 digit otp code from YOPP";
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(width / 7),
                  fieldHeight: width / 7,
                  fieldWidth: width / 7,
                  borderWidth: 0,
                  activeColor: Colors.black.withOpacity(0.2),
                  activeFillColor: Colors.black.withOpacity(0.2),
                  inactiveColor: Colors.black.withOpacity(0.2),
                  inactiveFillColor: Colors.black.withOpacity(0.2),
                  disabledColor: Colors.black.withOpacity(0.2),
                  selectedColor: Colors.black.withOpacity(0.2),
                  selectedFillColor: Colors.black.withOpacity(0.2),
                ),
                cursorColor: Colors.white,
                animationDuration: Duration(milliseconds: 300),
                textStyle: TextStyle(fontSize: 28, color: Colors.white),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                errorAnimationController: null,
                controller: textEditingController,
                keyboardType: TextInputType.phone,
                onCompleted: (v) {},
                onChanged: (value) {},
                beforeTextPaste: (text) {
                  return true;
                },
              ),
              SizedBox(height: 16),
              FlatButton(
                color: AppColors.green,
                height: 50,
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    BlocProvider.of<OtpBloc>(context, listen: false).add(
                      VerifyOtpEvent(textEditingController.text),
                    );
                  }
                },
                child: Text(
                  "CONFIRM",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          )),
    );
  }

  _showGenderSelectScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(GenderSelectScreen.routeName);
  }
}
