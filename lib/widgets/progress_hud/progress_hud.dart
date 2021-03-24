import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum ProgressHudType {
  /// show loading with CupertinoActivityIndicator and text
  loading,

  /// show Icons.check and Text
  success,

  /// show Icons.close and Text
  error,

  /// show circle progress view and text
  progress
}

/// show progresshud like ios app
class ProgressHud extends StatefulWidget {
  /// the offsetY of hudview postion from center, default is -50
  final double offsetY;
  final Widget child;
  // max duration for auto dismiss hud
  final Duration maximumDismissDuration;

  static ProgressHudState of(BuildContext context) {
    return context.findAncestorStateOfType<ProgressHudState>();
  }

  ProgressHud(
      {@required this.child,
      this.offsetY = -50,
      this.maximumDismissDuration = const Duration(milliseconds: 2000),
      Key key})
      : super(key: key);

  @override
  ProgressHudState createState() => ProgressHudState();
}

class ProgressHudState extends State<ProgressHud> {
  var _isVisible = false;
  var _text = "";
  double _opacity = 0.0;
  var _progressType = ProgressHudType.loading;

  /// dismiss hud
  void dismiss() {
    setState(() {
      _opacity = 0;
    });
  }

  /// show hud with type and text
  void show(ProgressHudType type, String text) {
    _text = text;
    _isVisible = true;
    _progressType = type;
    setState(() {
      _opacity = 1;
    });
  }

  /// show loading with text
  void showLoading({String text = "loading"}) {
    this.show(ProgressHudType.loading, text);
  }

  /// show success icon with text and dismiss automatic
  Future showSuccessAndDismiss({String text}) async {
    await this.showAndDismiss(ProgressHudType.success, text);
  }

  /// show error icon with text and dismiss automatic
  Future showErrorAndDismiss({String text}) async {
    await this.showAndDismiss(ProgressHudType.error, text);
  }

  /// show hud and dismiss automatically
  Future showAndDismiss(ProgressHudType type, String text) async {
    show(type, text);
    var millisecond;
    millisecond = max(500 + text.length * 200, 1000);
    if (type == ProgressHudType.error) {
      millisecond = 2000;
    }

    var duration = Duration(milliseconds: millisecond);
    if (widget.maximumDismissDuration != null &&
        widget.maximumDismissDuration.inMilliseconds <
            duration.inMilliseconds) {
      duration = widget.maximumDismissDuration;
    }
    await Future.delayed(duration);
    dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Offstage(
          offstage: !_isVisible,
          child: AnimatedOpacity(
            onEnd: () {
              if (_opacity == 0 && _isVisible) {
                // hide
                setState(() {
                  _isVisible = false;
                });
              }
            },
            opacity: _opacity,
            duration: Duration(milliseconds: 250),
            child: _createHud(),
          ),
        )
      ],
    );
  }

  Widget _createHud() {
    const double kIconSize = 50;
    switch (_progressType) {
      case ProgressHudType.loading:
        var sizeBox = SizedBox(
          width: kIconSize,
          height: kIconSize,
          child: CupertinoTheme(
              data: CupertinoTheme.of(context)
                  .copyWith(brightness: Brightness.dark),
              child: CupertinoActivityIndicator(animating: true, radius: 15)),
        );
        return _createHudView(sizeBox);
      case ProgressHudType.error:
        return _createHudView(
            Icon(Icons.close, color: Colors.white, size: kIconSize));
      case ProgressHudType.success:
        return _createHudView(
            Icon(Icons.check, color: Colors.white, size: kIconSize));
      case ProgressHudType.progress:
        return _createHudView(CircularProgressIndicator());
      default:
        throw Exception("not implementation");
    }
  }

  Widget _createHudView(Widget child) {
    return Stack(
      children: <Widget>[
        // do not response touch event
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withOpacity(0.2),
        ),

        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10 - widget.offsetY * 2),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 33, 33, 33),
                  borderRadius: BorderRadius.circular(5)),
              constraints: BoxConstraints(
                  minHeight: 130,
                  minWidth: 130,
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      child: child,
                    ),
                    Container(
                      child: Text(_text,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
