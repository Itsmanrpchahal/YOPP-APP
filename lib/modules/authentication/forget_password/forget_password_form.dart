import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/validator.dart';
import 'package:yopp/modules/authentication/forget_password/bloc/forget_bloc.dart';
import 'package:yopp/modules/authentication/forget_password/bloc/forget_event.dart';
import 'package:yopp/widgets/textfield/auth_field.dart';

class ForgetPasswordForm extends StatefulWidget {
  @override
  _ForgetPasswordFormState createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              controller: _emailController,
              placeHolderText: "Email address",
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                return Validator.isEmail(value)
                    ? null
                    : "Please, Enter the valid Email.";
              },
            ),
            SizedBox(height: 20),
            FlatButton(
              color: AppColors.green,
              height: 50,
              onPressed: () => _forgotPasswordAction(context),
              child: Text(
                "RESET PASSWORD",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ));
  }

  _forgotPasswordAction(BuildContext context) {
    if (_formkey.currentState.validate()) {
      BlocProvider.of<ForgotBloc>(context, listen: false)
          .add(ForgotPasswordEvent(_emailController.text));
    }
  }
}
