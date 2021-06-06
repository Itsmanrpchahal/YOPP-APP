import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/models/interest.dart';

class InterestListWidget extends StatelessWidget {
  final String selectedInterestId;
  final List<InterestOption> interestOptions;

  final Function(InterestOption) onTap;

  const InterestListWidget(
      {Key key,
      @required this.selectedInterestId,
      @required this.onTap,
      @required this.interestOptions})
      : super(key: key);

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
              "SELECT A SPORT CATEGORY",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                children: interestOptions
                    .map((e) => Container(
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          height: 36,
                          child: InkWell(
                            onTap: () {
                              onTap(e);
                            },
                            child: Container(
                                margin: EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    Radio(
                                        value: e.id,
                                        groupValue: selectedInterestId ?? "-1",
                                        activeColor: AppColors.green,
                                        onChanged: (index) {
                                          onTap(e);
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
