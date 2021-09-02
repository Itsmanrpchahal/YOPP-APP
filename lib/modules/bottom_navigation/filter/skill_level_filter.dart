import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';

class SkillLevelList extends StatelessWidget {
  final String previousScreenName;
  final String previousSelection;
  final SkillLevel selectedSkillLevel;
  final Function onBack;
  final Function(SkillLevel) onSelected;

  const SkillLevelList({
    Key key,
    @required this.previousSelection,
    @required this.selectedSkillLevel,
    @required this.onBack,
    @required this.onSelected,
    @required this.previousScreenName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: AppColors.green,
            alignment: Alignment.center,
            height: 60,
            child: Text(
              "SELECT SKILL LEVEL",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          InkWell(
            onTap: onBack,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    previousScreenName,
                    style: TextStyle(color: AppColors.green, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.green,
                        size: 14,
                      ),
                      Text(
                        previousSelection,
                        style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      Icon(
                        Icons.arrow_back,
                        color: AppColors.green,
                        size: 14,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                children: SkillLevel.values
                    .where((element) => element != SkillLevel.all)
                    .map((e) => Container(
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          height: 36,
                          child: InkWell(
                            onTap: () => onSelected(e),
                            child: Container(
                                margin: EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    Radio(
                                        value: e.index,
                                        groupValue:
                                            selectedSkillLevel?.index ?? -1,
                                        activeColor: AppColors.green,
                                        onChanged: (index) {
                                          onSelected(e);
                                        }),
                                    Text(
                                      e.name,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: AppColors.green, fontSize: 12),
                                    ),
                                  ],
                                )),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
