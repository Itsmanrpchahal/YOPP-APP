library dots_indicator;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'dots_decorator.dart';

typedef void OnTap(double position);

class DotsIndicator extends StatelessWidget {
  final int dotsCount;
  final double position;
  final DotsDecorator decorator;
  final Axis axis;
  final bool reversed;
  final OnTap onTap;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  const DotsIndicator({
    Key key,
    this.dotsCount,
    this.position = 0.0,
    this.decorator = const DotsDecorator(),
    this.axis = Axis.horizontal,
    this.reversed = false,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onTap,
  })  : assert(dotsCount > 0),
        assert(position >= 0),
        assert(
          position < dotsCount,
          "Position must be inferior than dotsCount",
        ),
        super(key: key);

  Widget _buildDot(int index) {
    final state = min(1.0, (position - index).abs());

    final size = Size.lerp(decorator.activeSize, decorator.size, state);
    final color = Color.lerp(decorator.activeColor, decorator.color, state);
    final shape = ShapeBorder.lerp(
      decorator.activeShape,
      decorator.shape,
      state,
    );

    final dot = Container(
        margin: decorator.spacing,
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(size.width),
            border: Border.all(
              width: 2.0,
              color:
                  decorator.showInactiveBorder ? decorator.activeColor : color,
            )),
        child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: ShapeDecoration(
            color: color,
            shape: shape,
          ),
        ));
    return onTap == null
        ? dot
        : InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onTap(index.toDouble()),
            child: dot,
          );
  }

  @override
  Widget build(BuildContext context) {
    final dotsList = List<Widget>.generate(dotsCount, _buildDot);
    final dots = reversed == true ? dotsList.reversed.toList() : dotsList;

    return axis == Axis.vertical
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: dots,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: dots,
          );
  }
}