import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/widgets/icons/default_user_icon.dart';

class ProfileIcon extends StatelessWidget {
  final File image;
  final String imageUrl;
  final Gender gender;

  const ProfileIcon({
    Key key,
    this.image,
    this.imageUrl,
    this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Image.file(
        image,
        fit: BoxFit.cover,
      );
    }

    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => gender == null
            ? Container()
            : gender == Gender.male
                ? MaleIcon()
                : FemaleIcon(),
      );
    }
    return gender == null
        ? Container()
        : gender == Gender.male
            ? MaleIcon()
            : FemaleIcon();
  }
}
