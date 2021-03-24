import 'package:flutter/material.dart';

class DimContainer extends StatelessWidget {
  final Widget child;

  const DimContainer({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Container(
          color: Colors.black45,
        )
      ],
    );
  }
}
