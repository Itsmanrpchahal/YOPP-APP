import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class RetryWidget extends StatelessWidget {
  final Function onRetry;
  final String errorDescription;

  const RetryWidget({
    Key key,
    this.onRetry,
    this.errorDescription,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorDescription ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.green, fontSize: 18),
            ),
            SizedBox(height: 8),
            FlatButton.icon(
              onPressed: onRetry,
              icon: CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.green,
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              label: Text(
                "Retry",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.green, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
