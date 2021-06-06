import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/widgets/icons/default_user_icon.dart';
import 'dart:math';

class ActiveCircularProfileIcon extends StatelessWidget {
  const ActiveCircularProfileIcon({
    Key key,
    @required this.imageUrl,
    @required this.isOnline,
    @required this.gender,
    this.size = 50,
  }) : super(key: key);

  final double size;
  final String imageUrl;
  final Gender gender;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final radius = size / 2;
    var distance = sqrt((radius * radius) / 2);
    final statusSize = size / 8;
    final offset = radius - distance - statusSize;

    return Container(
      height: size,
      width: size,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircularProfileIconWithShadow(
            imageUrl: imageUrl,
            gender: gender,
            size: size,
          ),
          Positioned(
            right: offset,
            top: offset,
            child: CircleAvatar(
              radius: statusSize,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: statusSize * 0.8,
                backgroundColor:
                    isOnline ? AppColors.onlineGreen : AppColors.orange,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CircularProfileIcon extends StatelessWidget {
  const CircularProfileIcon({
    Key key,
    @required this.imageUrl,
    @required this.gender,
    this.size = 50,
  }) : super(key: key);

  final String imageUrl;
  final double size;
  final Gender gender;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: AppColors.lightGrey,
        child: Container(
            margin: EdgeInsets.all(size / 6),
            child: gender == null
                ? Container()
                : gender == Gender.male
                    ? MaleIcon()
                    : FemaleIcon()),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: size,
          width: size,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Container(
            margin: EdgeInsets.all(size / 6),
            child: gender == null
                ? Container()
                : gender == Gender.male
                    ? MaleIcon()
                    : FemaleIcon()),
      );
    }
  }
}

class CircularProfileIconWithShadow extends StatelessWidget {
  const CircularProfileIconWithShadow({
    Key key,
    @required this.imageUrl,
    @required this.gender,
    this.size = 50,
  }) : super(key: key);

  final String imageUrl;
  final double size;
  final Gender gender;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: AppColors.lightGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  blurRadius: 2,
                  spreadRadius: 2)
            ]),
        child: Container(
            margin: EdgeInsets.all(size / 6),
            child: gender == null
                ? Container()
                : gender == Gender.male
                    ? MaleIcon()
                    : FemaleIcon()),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: size,
          width: size,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  blurRadius: 2,
                  spreadRadius: 2)
            ],
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 0),
                    blurRadius: 2,
                    spreadRadius: 2)
              ]),
          child: Container(
              margin: EdgeInsets.all(size / 6),
              child: gender == null
                  ? Container()
                  : gender == Gender.male
                      ? MaleIcon()
                      : FemaleIcon()),
        ),
      );
    }
  }
}
