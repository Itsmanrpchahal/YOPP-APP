import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolderText;
  final TextInputType keyboardType;
  final String Function(String) validator;
  final int numberOfLines;
  final bool obscureText;
  final bool enabled;

  const AuthField({
    Key key,
    @required this.controller,
    this.placeHolderText,
    this.keyboardType,
    this.validator,
    this.numberOfLines,
    this.enabled = true,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      textCapitalization: TextCapitalization.sentences,
      obscureText: obscureText,
      maxLines: numberOfLines ?? 1,
      decoration: buildInputDecoration(),
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
      keyboardType: keyboardType ?? TextInputType.name,
      validator: validator,
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white.withOpacity(1)),
      errorStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
