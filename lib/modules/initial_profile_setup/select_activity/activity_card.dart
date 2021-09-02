import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/_common/sports/sports.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key key,
    @required this.sport,
    @required this.paddingUnit,
    @required this.onTap,
  }) : super(key: key);

  final Sport sport;
  final double paddingUnit;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(paddingUnit),
        padding: EdgeInsets.all(4),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Hexcolor("#707070")),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.green,
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              sport.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Hexcolor("#999999"),
                  ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  sport.imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
