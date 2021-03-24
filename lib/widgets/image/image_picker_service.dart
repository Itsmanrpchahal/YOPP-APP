import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

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

  // static Future<bool> _checkCameraPermission() async {
  //   var status = await Permission.camera.request();
  //   switch (status) {
  //     case PermissionStatus.granted:
  //       return true;
  //       break;
  //     default:
  //       return false;
  //       break;
  //   }
  // }

  // static Future<bool> _checkGallaryPermission() async {
  //   var status = await Permission.photos.request();
  //   switch (status) {
  //     case PermissionStatus.granted:
  //       return true;
  //       break;
  //     default:
  //       return false;
  //       break;
  //   }
  // }

  static Future<File> _openGallary(BuildContext context) async {
    // final permission = await _checkGallaryPermission();
    // if (!permission) {
    //   return;
    // }
    try {
      final pickedFile =
          await _picker.getImage(source: ImageSource.gallery, maxWidth: 1024);
      return pickedFile == null ? null : File(pickedFile.path);
    } catch (error) {
      return null;
    }
  }

  static Future<File> _openCamera(BuildContext context) async {
    // final permission = await _checkCameraPermission();
    // if (!permission) {
    //   return;
    // }
    try {
      final pickedFile =
          await _picker.getImage(source: ImageSource.camera, maxWidth: 1024);
      return pickedFile == null ? null : File(pickedFile.path);
    } catch (error) {
      return null;
    }
  }
}
