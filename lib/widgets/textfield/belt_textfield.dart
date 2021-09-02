import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class BeltField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolderText;
  final TextInputType keyboardType;
  final String Function(String) validator;
  final Function(String) onChanged;

  const BeltField(
      {Key key,
      @required this.controller,
      this.placeHolderText,
      this.keyboardType,
      this.validator,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        decoration: buildInputDecoration(),
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
        maxLength: 20,
        keyboardType: keyboardType ?? TextInputType.name,
        validator: validator,
      ),
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: AppColors.lightGrey,
      ),
      errorStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white,
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
      fillColor: Colors.white,
      counterText: "",
    );
  }
}
