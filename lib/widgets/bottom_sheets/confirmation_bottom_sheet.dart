import 'package:flutter/material.dart';

class ConfirmationBottomSheet {
  static show(BuildContext context, String title, Function onConfirmed) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        builder: (context) => Container(
              child: SafeArea(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32, top: 32, right: 32, bottom: 16),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton.icon(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onConfirmed();
                            },
                            icon: Icon(Icons.check),
                            label: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton.icon(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.cancel),
                            label: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        )
                      ],
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.check),
                    //   title: Text('Confirm'),
                    //   onTap: () {
                    //     onConfirmed();
                    //     Navigator.of(context).pop();
                    //   },
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.cancel),
                    //   title: Text('Cancel'),
                    //   onTap: () => Navigator.of(context).pop(),
                    // )
                  ],
                ),
              ),
            ));
  }
}
