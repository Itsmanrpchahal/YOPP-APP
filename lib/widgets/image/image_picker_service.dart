import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

typedef imageFunction = Function(File image);

class ImagePickerService {
  static final _picker = ImagePicker();

  static Future<File> getImage(BuildContext context) async {
    var image = await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 200,
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () async {
                  final image = await _openCamera(context);
                  Navigator.of(context).pop(image);
                },
                leading: Icon(Icons.photo_camera),
                title: Text('Open Camera'),
              ),
              ListTile(
                onTap: () {
                  _openGallary(context)
                      .then((value) => Navigator.of(context).pop(value));
                },
                leading: Icon(Icons.photo_library),
                title: Text('Open Image Gallery'),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop(null);
                },
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );

    return image;
    //
  }

  static Future<File> _openGallary(BuildContext context) async {
    try {
      final pickedFile =
          await _picker.getImage(source: ImageSource.gallery, maxWidth: 1024);
      return pickedFile == null ? null : File(pickedFile.path);
    } catch (error) {
      print(error);
      if (error.code == 'photo_access_denied') {
        await showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Photo Permission'),
                  content: Text(
                      'We need to access the photos to take a picture for your profile in the app.'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('Deny'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoDialogAction(
                      child: Text('Settings'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        openAppSettings();
                      },
                    ),
                  ],
                ));
      }

      return null;
    }
  }

  static Future<File> _openCamera(BuildContext context) async {
    try {
      final pickedFile =
          await _picker.getImage(source: ImageSource.camera, maxWidth: 1024);
      return pickedFile == null ? null : File(pickedFile.path);
    } catch (error) {
      print(error);
      if (error.code == 'camera_access_denied') {
        await showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Camera Permission'),
                  content: Text(
                      'We need to access the camera to take a picture for your profile in the app.'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('Deny'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoDialogAction(
                      child: Text('Settings'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        openAppSettings();
                      },
                    ),
                  ],
                ));
      }
      return null;
    }
  }
}
