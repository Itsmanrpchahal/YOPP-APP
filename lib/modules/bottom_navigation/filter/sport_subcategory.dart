import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/models/interest.dart';

class CategoryListWidget extends StatelessWidget {
  final InterestOption selectedInterestOption;
  final String selectedCategoryId;
  final Function onBack;
  final Function(CategoryOption) onSelected;

  const CategoryListWidget(
      {Key key,
      @required this.selectedInterestOption,
      @required this.selectedCategoryId,
      @required this.onBack,
      @required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: AppColors.green,
            alignment: Alignment.center,
            height: 60,
            child: Text(
              "SELECT SUB-CATEGORY",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          InkWell(
            onTap: () => onBack(),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Change Selected Category",
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
                        selectedInterestOption?.name ?? "",
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
                children: selectedInterestOption.category
                    .map((e) => Container(
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          child: InkWell(
                            onTap: () => onSelected(e),
                            child: Container(
                                height: 36,
                                margin: EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    Radio(
                                        value: e.id,
                                        groupValue: selectedCategoryId ?? "-1",
                                        activeColor: AppColors.green,
                                        onChanged: (index) {
                                          onSelected(e);
                                        }),
                                    Expanded(
                                      child: Text(
                                        e.name,
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 12),
                                      ),
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
