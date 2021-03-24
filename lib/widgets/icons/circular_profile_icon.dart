import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/widgets/icons/default_user_icon.dart';

class ActiveCircularProfileIcon extends StatelessWidget {
  const ActiveCircularProfileIcon({
    Key key,
    @required this.imageUrl,
    @required this.isOnline,
    @required this.gender,
  }) : super(key: key);

  final String imageUrl;
  final Gender gender;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircularProfileIcon(
            imageUrl: imageUrl,
            gender: gender,
          ),
          isOnline
              ? Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: AppColors.orange,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              : Container(),
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
        backgroundColor: Colors.white,
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
