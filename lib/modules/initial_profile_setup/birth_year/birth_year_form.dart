import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
import 'package:yopp/modules/authentication/bloc/authentication_event.dart';
import 'package:yopp/modules/initial_profile_setup/birth_year/bloc/birth_year_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/birth_year/bloc/birth_year_event.dart';

import 'package:yopp/widgets/progress_hud/progress_hud.dart';
import 'package:yopp/widgets/textfield/auth_field.dart';

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
  DateTime birthDate;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    print("dispose");
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return BlocListener<BirthYearBloc, BirthYearState>(
      child: _buildBody(context),
      listener: (context, state) async {
        print(state.status);
        ProgressHud.of(context).dismiss();
        switch (state.status) {
          case BirthYearServiceStatus.initial:
            break;
          case BirthYearServiceStatus.updating:
            ProgressHud.of(context)
                .show(ProgressHudType.loading, state.message);
            break;
          case BirthYearServiceStatus.success:
            Navigator.of(context).popUntil((route) => route.isFirst);
            BlocProvider.of<AuthBloc>(context, listen: false)
                .add(AuthStatusRequestedEvent());
            break;

          case BirthYearServiceStatus.failure:
            await ProgressHud.of(context)
                .showAndDismiss(ProgressHudType.error, state.message);
            break;

          case BirthYearServiceStatus.underAgeAlert:
            showUnderAgeDialog(context);

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
            AuthField(
              controller: textEditingController,
              readOnly: true,
              keyboardType: TextInputType.numberWithOptions(signed: true),
              placeHolderText: "Enter Your Date Of Birth",
              validator: (code) {
                return code.isNotEmpty
                    ? null
                    : "Please, select the birth year.";
              },
              onTap: () => showDatePicker(context),
            ),
            SizedBox(height: 32),
            FlatButton(
                onPressed: () {
                  print("onP");
                  if (_formkey.currentState.validate()) {
                    print("validate");

                    BlocProvider.of<BirthYearBloc>(context, listen: false)
                        .add(BirthYearSelectionEvent(birthDate));
                  } else {
                    print("invalidate");
                    birthDate = null;
                    textEditingController.clear();
                  }
                },
                color: AppColors.green,
                height: 50,
                child: Text(
                  "CONFIRM",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ))
          ],
        ));
  }

  Future<void> showDatePicker(BuildContext context) async {
    if (birthDate == null) {
      final date = DateTime.tryParse(textEditingController.text) ??
          DateTime.now().subtract(Duration(days: 18 * 365));

      if (date != null) {
        birthDate = date;
        textEditingController.text = DateFormat.yMMMd().format(date);
      }
    }
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: birthDate,
                minimumYear: DateTime.now().year - 100,
                minimumDate: DateTime.now().subtract(Duration(days: 365 * 100)),
                maximumYear: DateTime.now().year,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (date) {
                  print(date.year.toString());
                  setState(() {
                    if (date != null) {
                      birthDate = date;
                      textEditingController.text =
                          DateFormat.yMMMd().format(date);
                    }
                  });
                }),
          );
        });
  }

  Future<void> showUnderAgeDialog(BuildContext context) async {
    await showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)), //this right here
            child: Container(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Be vigilant ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "18+ Disclaimer",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'If you are under 18, please make sure you have your parents permission to meet people and practise your sport. We take pride in keeping everyone safe.',
                    maxLines: 8,
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                  SizedBox(height: 64),
                  Builder(
                    builder: (context) => RaisedButton.icon(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();

                        BlocProvider.of<BirthYearBloc>(context, listen: false)
                            .add(UnderAgePermissionEvent(birthDate));
                      },
                      icon: Icon(
                        Icons.check,
                        color: AppColors.orange,
                      ),
                      label: Container(
                        height: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
