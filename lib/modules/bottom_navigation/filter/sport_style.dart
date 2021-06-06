import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/models/interest.dart';

class SubCategoryListWidget extends StatelessWidget {
  final CategoryOption selectedCategory;
  final String selectedSubCategoryId;
  final Function onBack;
  final Function(SubCategoryOption) onTap;

  const SubCategoryListWidget(
      {Key key,
      @required this.selectedCategory,
      @required this.selectedSubCategoryId,
      @required this.onBack,
      @required this.onTap})
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
              "SELECT SPORT STYLE",
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
                    "Change Selected Sub-Category",
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
                        selectedCategory?.name ?? "",
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
                children: selectedCategory.subCategory
                    .map((e) => Container(
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          height: 36,
                          child: InkWell(
                            onTap: () => onTap(e),
                            child: Container(
                                margin: EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    Radio(
                                        value: e.id,
                                        groupValue:
                                            selectedSubCategoryId ?? "-1",
                                        activeColor: AppColors.green,
                                        onChanged: (index) {
                                          onTap(e);
                                        }),
                                    Expanded(
                                      child: Text(
                                        e.name,
                                        textAlign: TextAlign.start,
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
