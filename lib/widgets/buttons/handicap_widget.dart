import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yopp/helper/app_constants.dart';

class HandicapWidget extends StatefulWidget {
  final int handicapLevel;
  final Function(int handicapLevel) onChanged;

  const HandicapWidget({Key key, this.handicapLevel, this.onChanged})
      : super(key: key);

  @override
  _HandicapWidgetState createState() => _HandicapWidgetState();
}

class _HandicapWidgetState extends State<HandicapWidget> {
  int handicapLevel;

  @override
  void initState() {
    handicapLevel =
        widget.handicapLevel ?? PreferenceConstants.defaultHandicapLevel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        margin: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  "What's Your handicap",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 16),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                handicapLevel.toString(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              height: 300,
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: handicapLevel),
                magnification: 1.2,
                useMagnifier: true,
                itemExtent: 40.0,
                backgroundColor: Colors.white,
                onSelectedItemChanged: (value) {
                  widget.onChanged(value);
                  setState(() {
                    handicapLevel = value;
                  });
                },
                children: List<int>.generate(37, (i) => i)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.toString(),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ));
  }
}
