import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/app_gradients.dart';

class GradientCheckButton extends StatelessWidget {
  const GradientCheckButton({
    Key key,
    @required this.onPressed,
    this.radius = 22,
  }) : super(key: key);

  final double radius;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GradientCircleButton(
      onPressed: onPressed,
      radius: radius,
      icon: Icons.check,
    );
  }
}

class ChatSendButton extends StatelessWidget {
  const ChatSendButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GradientCircleButton(
      onPressed: onPressed,
      icon: Icons.send_rounded,
    );
  }
}

class GradientCircleButton extends StatelessWidget {
  const GradientCircleButton({
    Key key,
    @required this.onPressed,
    this.radius = 22,
    this.icon,
  }) : super(key: key);

  final double radius;
  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: radius * 2,
        width: radius * 2,
        child: Icon(
          icon,
          color: Colors.white,
          size: radius,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            gradient: AppGradients.backgroundGradient,
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 8)
            ]),
      ),
    );
  }
}

class CheckButton extends StatelessWidget {
  const CheckButton({
    Key key,
    @required this.onPressed,
    this.radius = 22,
  }) : super(key: key);

  final double radius;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: radius * 2,
        width: radius * 2,
        child: Icon(
          Icons.check,
          color: AppColors.orange,
          size: radius,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 8)
            ]),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool enabled;

  const GradientButton(
      {Key key, this.onPressed, this.child, this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: enabled ? null : Colors.black26,
        gradient: enabled ? AppGradients.halfBackgroundGradient : null,
      ),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
