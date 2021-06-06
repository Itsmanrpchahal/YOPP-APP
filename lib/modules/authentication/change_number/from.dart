import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/authentication/change_number/bloc/change_number_bloc.dart';
import 'package:yopp/modules/authentication/change_number/bloc/change_number_event.dart';

import 'package:yopp/modules/authentication/sign_up/ui/country_picker.dart';

import 'package:yopp/widgets/textfield/auth_field.dart';

class NumberForm extends StatefulWidget {
  final String countryCode;
  final String phoneNumber;

  const NumberForm({
    Key key,
    @required this.countryCode,
    @required this.phoneNumber,
  }) : super(key: key);
  @override
  _NumberFormState createState() => _NumberFormState();
}

class _NumberFormState extends State<NumberForm> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _phoneController;
  String _countryCode;
  String phoneNumberError;

  @override
  void initState() {
    _countryCode = widget.countryCode;
    _phoneController = TextEditingController(text: widget.phoneNumber);
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
              SizedBox(height: 40),
              _buildPhoneNumberSection(context),
              SizedBox(height: 32),
              Builder(builder: (context) {
                return FlatButton(
                  color: AppColors.green,
                  height: 50,
                  onPressed: () {
                    _register(context);
                  },
                  child: Text(
                    "CONFIRM",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              })
            ],
          )),
    );
  }

  _buildPhoneNumberSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountryPicker(
          initialCountryCode: _countryCode,
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
            validator: (value) {
              return phoneNumberError;
            },
            onChanged: (value) => checkPhoneNumberError(),
          ),
        ),
      ],
    );
  }

  Future<void> checkPhoneNumberError() async {
    try {
      final parsed = await FlutterLibphonenumber()
          .parse(_countryCode + _phoneController.text);
      print(parsed);
      phoneNumberError = null;
    } catch (error) {
      if (_phoneController.text.isEmpty) {
        phoneNumberError = "Enter Phone Number.";
      } else {
        phoneNumberError = "Enter valid Phone Number.";
      }
    }
  }

  _register(BuildContext context) {
    if (_formkey.currentState.validate() && phoneNumberError == null) {
      BlocProvider.of<ChangeNumberBloc>(context, listen: false)
          .add(UpdateNumberEvent(_countryCode, _phoneController.text));
    }
  }
}
