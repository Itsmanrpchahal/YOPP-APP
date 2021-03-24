import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String labelText;
  final Function onPressed;
  final bool enabled;

  const CustomDropdownButton(
      {Key key, this.labelText, this.onPressed, this.enabled = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                labelText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            enabled
                ? Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
