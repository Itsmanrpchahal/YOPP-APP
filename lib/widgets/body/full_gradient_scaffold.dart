import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_gradients.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class FullGradientScaffold extends StatelessWidget {
  final Widget body;
  final AppBar appBar;
  final LinearGradient gradient;
  final bool hideGradient;
  final bool extendBodyBehindAppBar;

  FullGradientScaffold({
    @required this.body,
    this.appBar,
    this.gradient,
    this.hideGradient,
    this.extendBodyBehindAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        extendBodyBehindAppBar: true,
        body: hideGradient == true
            ? body
            : Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        gradient: gradient ?? AppGradients.backgroundGradient),
                  ),
                  Column(
                    children: [
                      extendBodyBehindAppBar
                          ? Container()
                          : Container(
                              height: appBar != null
                                  ? appBar.preferredSize.height +
                                      MediaQuery.of(context).viewPadding.top
                                  : 0,
                            ),
                      Expanded(child: body),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
