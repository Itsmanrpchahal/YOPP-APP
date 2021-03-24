import 'package:flutter/material.dart';

class BackgroundCard extends StatelessWidget {
  const BackgroundCard({
    Key key,
    @required this.height,
    @required this.padding,
    @required this.child,
  }) : super(key: key);

  final double height;
  final double padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.66,
      child: Container(
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(padding / 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 34.3,
                  offset: Offset(0, 25))
            ]),
        child: child,
      ),
    );
  }
}
