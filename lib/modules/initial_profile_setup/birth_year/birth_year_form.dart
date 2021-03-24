import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yopp/modules/initial_profile_setup/birth_year/bloc/birth_year_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/birth_year/bloc/birth_year_event.dart';
import 'package:yopp/modules/initial_profile_setup/birth_year/under_age_dialog.dart';
import 'package:yopp/modules/initial_profile_setup/select_ability/select_ability_screen.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/select_activity_screen.dart';

import 'package:yopp/widgets/buttons/auth_rounded_button.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import 'bloc/birth_year_state.dart';

class BirthYearFrom extends StatefulWidget {
  @override
  _BirthYearFromState createState() => _BirthYearFromState();
}

class _BirthYearFromState extends State<BirthYearFrom> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BirthYearBloc, BirthYearState>(
      child: _buildBody(context),
      listener: (context, state) async {
        ProgressHud.of(context).dismiss();
        switch (state.status) {
          case BirthYearServiceStatus.initial:
            break;
          case BirthYearServiceStatus.updating:
            ProgressHud.of(context)
                .show(ProgressHudType.loading, state.message);
            break;
          case BirthYearServiceStatus.success:
            Navigator.of(context).push(SelectActivityScreen.route(
                isInitialSetupScreen: SelectAbilityEnum.initialSetup));

            break;
          case BirthYearServiceStatus.failure:
            ProgressHud.of(context)
                .showAndDismiss(ProgressHudType.error, state.message);
            break;

          case BirthYearServiceStatus.underAgeAlert:
            UnderAgeDialog.show(context, then: () {
              final birthYear = int.parse(textEditingController.text) ?? 0;
              BlocProvider.of<BirthYearBloc>(context)
                  .add(UnderAgePermissionEvent(birthYear));
            });

            break;
        }
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
        key: _formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PinCodeTextField(
              appContext: context,
              pastedTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              length: 4,
              obscureText: false,
              obscuringCharacter: '*',
              animationType: AnimationType.fade,
              validator: (code) {
                return code.length == 4
                    ? null
                    : "Please, select the birth year.";
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(30),
                fieldHeight: 60,
                fieldWidth: 60,
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
              keyboardType: TextInputType.number,

              onCompleted: (v) {
                print("onComplete");
              },
              // onTap: () {
              //   print("Pressed");
              // },
              onChanged: (value) {
                print(value);
                setState(() {
                  currentText = value;
                });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            ),
            SizedBox(height: 16),
            AuthRoundedButton(
              onPressed: () {
                if (_formkey.currentState.validate()) {
                  print("validate");
                  final birthYear = int.parse(textEditingController.text) ?? 0;

                  BlocProvider.of<BirthYearBloc>(context)
                      .add(BirthYearSelectionEvent(birthYear));
                } else {
                  print("invalidate");
                  textEditingController.clear();
                }
              },
            ),
          ],
        ));
  }
}
