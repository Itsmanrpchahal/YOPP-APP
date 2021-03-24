import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcard/tcard.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_bloc.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_event.dart';

import '../../bottom_nav_appBar.dart';

class DiscoverButtonSection extends StatelessWidget {
  const DiscoverButtonSection({
    @required this.enableMatchButton,
    @required this.height,
    @required this.controller,
  });

  final bool enableMatchButton;
  final double height;
  final TCardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          enableMatchButton
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleIconButton(
                      onPressed: enableMatchButton
                          ? () {
                              controller.forward(direction: SwipDirection.Left);
                            }
                          : () {},
                      radius: height / 5,
                      backgrounColor: Colors.white10,
                      icon: Icon(
                        CupertinoIcons.multiply,
                        color: Colors.white,
                        size: height / 5,
                      ),
                    ),
                    SizedBox(width: height / 10),
                    Container(
                      child: CircleIconButton(
                        onPressed: enableMatchButton
                            ? () {
                                controller.forward(
                                    direction: SwipDirection.Right);
                              }
                            : () {},
                        radius: height / 5,
                        backgrounColor: Colors.white,
                        icon: Icon(
                          Icons.check,
                          color: AppColors.orange,
                          size: height / 5,
                        ),
                      ),
                    )
                  ],
                )
              : Container(
                  height: height / 2.5,
                ),
          CircleIconButton(
            onPressed: () {
              _refreshCards(context);
            },
            backgrounColor: Hexcolor("#222222").withOpacity(0.2),
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  void _refreshCards(BuildContext context) {
    print("Refresh");
    BlocProvider.of<DiscoverBloc>(context).add(DiscoverUsersEvent());
  }
}
