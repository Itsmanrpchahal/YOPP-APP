import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCheckBoxListTile extends StatelessWidget {
  final bool value;
  final String title;
  final void Function(bool) onChanged;

  const CustomCheckBoxListTile(
      {Key key, @required this.value, @required this.title, this.onChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            value
                ? Icon(
                    CupertinoIcons.checkmark_alt_circle,
                    size: 35.0,
                    color: Colors.white,
                  )
                : Icon(
                    CupertinoIcons.circle,
                    size: 35.0,
                    color: Colors.white,
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
