import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/validator.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolderText;
  final TextInputType keyboardType;
  final String Function(String) validator;
  final Widget suffix;
  final int numberOfLines;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final Function onTap;
  final Function(String) onChanged;
  final TextCapitalization textCapitalization;

  const AuthField({
    Key key,
    @required this.controller,
    this.placeHolderText,
    this.keyboardType = TextInputType.name,
    this.validator,
    this.numberOfLines,
    this.enabled = true,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.textCapitalization = TextCapitalization.sentences,
    this.suffix,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      enabled: enabled,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      maxLines: numberOfLines ?? 1,
      decoration: buildInputDecoration(suffix: suffix),
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  InputDecoration buildInputDecoration({Widget suffix}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white54,
      ),
      suffixIcon: suffix != null
          ? suffix
          : Container(
              width: 0,
            ),
      errorStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          width: 2,
          color: Colors.white,
          style: BorderStyle.solid,
        ),
      ),
      border: new OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      hintText: placeHolderText ?? "",
      floatingLabelBehavior: FloatingLabelBehavior.never,
      alignLabelWithHint: true,
      filled: true,
      fillColor: enabled
          ? Colors.white.withOpacity(0.25)
          : Colors.white.withOpacity(0.2),
      counterText: "",
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolderText;
  final TextInputType keyboardType;
  final String Function(String) validator;
  final int numberOfLines;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final Function onTap;
  final String suffixText;
  final TextAlign textAlign;

  const CustomTextField({
    Key key,
    @required this.controller,
    this.placeHolderText,
    this.keyboardType,
    this.validator,
    this.numberOfLines,
    this.enabled = true,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.suffixText,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      enabled: enabled,
      textAlign: textAlign ?? TextAlign.start,
      textCapitalization: TextCapitalization.sentences,
      obscureText: obscureText,
      maxLines: numberOfLines ?? 1,
      decoration: buildInputDecoration(suffixText: suffixText),
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.darkGreen,
          fontSize: 14),
      keyboardType: keyboardType ?? TextInputType.name,
      validator: validator,
    );
  }

  InputDecoration buildInputDecoration({String suffixText}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.green.withOpacity(0.5),
      ),
      suffixText: suffixText,
      errorStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          width: 2,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
      ),
      border: new OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      hintText: placeHolderText ?? "sss",
      floatingLabelBehavior: FloatingLabelBehavior.never,
      alignLabelWithHint: true,
      filled: true,
      fillColor: enabled ? Colors.black12 : Colors.black12,
      counterText: "",
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key key,
    @required TextEditingController passwordController,
  })  : _passwordController = passwordController,
        super(key: key);

  final TextEditingController _passwordController;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool hidePassword = true;

  void togglePasswordVisibility() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthField(
      controller: widget._passwordController,
      obscureText: hidePassword,
      suffix: FlatButton.icon(
          padding: EdgeInsets.zero,
          onPressed: () => togglePasswordVisibility(),
          icon: hidePassword
              ? Icon(
                  Icons.visibility,
                  color: Colors.white54,
                )
              : Icon(
                  Icons.visibility_off,
                  color: Colors.white54,
                ),
          label: Container()),
      placeHolderText: "Password",
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        return Validator.checkPasswordValidity(value);
      },
    );
  }
}
