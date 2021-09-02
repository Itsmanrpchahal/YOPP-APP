import 'package:flutter/material.dart';

class _JumpingDot extends AnimatedWidget {
  final Color color;
  final double size;

  _JumpingDot({Key key, Animation<double> animation, this.color, this.size})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
      height: animation.value + size,
      child: CircleAvatar(
        backgroundColor: color,
        radius: size,
      ),
    );
  }
}

class JumpingDotsProgressIndicator extends StatefulWidget {
  /// Number of dots that are added in a horizontal list, default = 3.
  final int numberOfDots;

  /// Font size of each dot, default = 10.0.
  final double size;

  /// Spacing between each dot, default 0.0.
  final double dotSpacing;

  /// Color of the dots, default black.
  final Color color;

  /// Time of one complete cycle of animation, default 250 milliseconds.
  final int milliseconds;

  /// Starting and ending values for animations.
  final double beginTweenValue = 0.0;
  final double endTweenValue = 8.0;

  /// Creates a jumping do progress indicator.
  JumpingDotsProgressIndicator({
    this.numberOfDots = 3,
    this.size = 10.0,
    this.color = Colors.black,
    this.dotSpacing = 0.0,
    this.milliseconds = 250,
  });

  _JumpingDotsProgressIndicatorState createState() =>
      _JumpingDotsProgressIndicatorState(
        numberOfDots: this.numberOfDots,
        size: this.size,
        color: this.color,
        dotSpacing: this.dotSpacing,
        milliseconds: this.milliseconds,
      );
}

class _JumpingDotsProgressIndicatorState
    extends State<JumpingDotsProgressIndicator> with TickerProviderStateMixin {
  int numberOfDots;
  int milliseconds;
  double size;
  double dotSpacing;
  Color color;
  List<AnimationController> controllers = new List<AnimationController>();
  List<Animation<double>> animations = new List<Animation<double>>();
  List<Widget> _widgets = new List<Widget>();

  _JumpingDotsProgressIndicatorState({
    this.numberOfDots,
    this.size,
    this.color,
    this.dotSpacing,
    this.milliseconds,
  });

  initState() {
    super.initState();
    for (int i = 0; i < numberOfDots; i++) {
      _addAnimationControllers();
      _buildAnimations(i);
      _addListOfDots(i);
    }

    controllers[0].forward();
  }

  void _addAnimationControllers() {
    controllers.add(AnimationController(
        duration: Duration(milliseconds: milliseconds), vsync: this));
  }

  void _addListOfDots(int index) {
    _widgets.add(
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: dotSpacing),
        child: _JumpingDot(
          animation: animations[index],
          size: size,
          color: color,
        ),
      ),
    );
  }

  void _buildAnimations(int index) {
    animations.add(
      Tween(begin: widget.beginTweenValue, end: widget.endTweenValue)
          .animate(controllers[index])
            ..addStatusListener(
              (AnimationStatus status) {
                if (status == AnimationStatus.completed)
                  controllers[index].reverse();
                if (index == numberOfDots - 1 &&
                    status == AnimationStatus.dismissed) {
                  controllers[0].forward();
                }
                if (animations[index].value > widget.endTweenValue / 2 &&
                    index < numberOfDots - 1) {
                  controllers[index + 1].forward();
                }
              },
            ),
    );
  }

  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size + (size * 0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _widgets,
        ),
      ),
    );
  }

  dispose() {
    for (int i = 0; i < numberOfDots; i++) controllers[i].dispose();
    super.dispose();
  }
}
