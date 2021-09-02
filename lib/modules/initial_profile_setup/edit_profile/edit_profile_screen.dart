// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:yopp/helper/app_color/app_gradients.dart';
// import 'package:yopp/helper/app_constants.dart';

// import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
// import 'package:yopp/modules/authentication/bloc/authentication_event.dart';
// import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
// import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
// import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/edit_profile_event.dart';
// import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/edit_profile_state.dart';
// import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

// import 'package:yopp/routing/transitions.dart';
// import 'package:yopp/widgets/body/half_gradient_scaffold.dart';

// import 'package:yopp/widgets/icons/profile_icon.dart';
// import 'package:yopp/widgets/progress_hud/progress_hud.dart';
// import 'package:yopp/widgets/slider/age_slider.dart';
// import 'package:yopp/widgets/slider/custom_slider.dart';
// import 'package:yopp/widgets/slider/height_slider.dart';
// import 'package:yopp/widgets/slider/weight_slider.dart';

// import 'package:yopp/widgets/buttons/auth_rounded_button.dart';
// import 'package:yopp/widgets/buttons/drop_down_button.dart';

// import 'package:yopp/widgets/image/image_picker_service.dart';
// import 'package:yopp/widgets/snackbar/custom_snackbar.dart';
// import 'package:yopp/widgets/textfield/auth_field.dart';

// import 'bloc/edit_profile_bloc.dart';

// class EditProfileScreen extends StatefulWidget {
//   static route(UserProfile profile, bool isInitialSetupScreen) => SlideRoute(
//       builder: (_) => EditProfileScreen(
//             profile: profile,
//             isInitialSetupScreen: isInitialSetupScreen,
//           ));

//   final UserProfile profile;
//   final bool isInitialSetupScreen;

//   const EditProfileScreen(
//       {Key key, @required this.profile, this.isInitialSetupScreen})
//       : super(key: key);

//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   GlobalKey<FormState> _formkey = GlobalKey<FormState>();

//   File _image;
//   String imageUrl;
//   TextEditingController _nameFieldController;
//   TextEditingController _aboutFieldController;
//   TextEditingController _addressFieldController;
//   double age;
//   double height;
//   double weight;

//   UserProfile profile;

//   @override
//   void initState() {
//     profile = widget.profile;
//     setupField();

//     if (profile == null) {
//       checkForUpdate(context);
//     }

//     super.initState();
//   }

//   void checkForUpdate(BuildContext context) {
//     BlocProvider.of<EditProfileBloc>(context, listen: false)
//         .add(GetUpdatedUserProfile());
//   }

//   void setupField() {
//     _nameFieldController = TextEditingController(text: profile?.name ?? "");
//     _aboutFieldController = TextEditingController(text: profile?.about ?? "");
//     _addressFieldController = TextEditingController(
//         text: (profile?.address?.subAdminArea ?? "") +
//             ", " +
//             (profile?.address?.adminArea ?? "") +
//             ", " +
//             (profile?.address?.countryName ?? ""));

//     age = profile?.age?.toDouble() ?? PreferenceConstants.minAgeValue;
//     height = profile?.height;

//     imageUrl = profile?.avatar;
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   void dispose() {
//     _nameFieldController.dispose();
//     _aboutFieldController.dispose();
//     _addressFieldController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ProgressHud(
//         child: BlocListener<EditProfileBloc, EditProfileState>(
//             listener: (context, state) {
//           print(state.status);
//           ProgressHud.of(context).dismiss();

//           switch (state.status) {
//             case EditProfileStatus.initial:
//               break;
//             case EditProfileStatus.loading:
//               ProgressHud.of(context)
//                   .show(ProgressHudType.loading, state.message);
//               break;
//             case EditProfileStatus.updating:
//               ProgressHud.of(context)
//                   .show(ProgressHudType.loading, state.message);
//               break;
//             case EditProfileStatus.updated:
//               if (widget.isInitialSetupScreen) {
//                 Navigator.of(context).popUntil((route) => route.isFirst);
//                 BlocProvider.of<AuthBloc>(context, listen: false)
//                     .add(AuthStatusRequestedEvent());
//               } else {
//                 profile = state.userProfile;
//                 BlocProvider.of<ProfileBloc>(context, listen: false)
//                     .add(LoadUserProfile());
//                 Navigator.of(context).pop();
//               }

//               break;
//             case EditProfileStatus.failure:
//               ProgressHud.of(context)
//                   .showAndDismiss(ProgressHudType.error, state.message);
//               break;

//             case EditProfileStatus.loaded:
//               profile = state.userProfile;
//               setupField();

//               break;
//           }
//         }, child: Builder(builder: (context) {
//           return HalfGradientScaffold(
//               titleText: "My Profile",
//               ratio: 0.4,
//               onActionPressed: () => _updateProfile(context),
//               gradientType: GradientType.bottomTopRight_curve,
//               showBackButton: Navigator.of(context).canPop(),
//               firstHalfBackground: Container(
//                 width: double.infinity,
//                 child: Hero(
//                   tag: "ProfileAvatar",
//                   child: ProfileIcon(
//                     imageUrl: imageUrl,
//                     gender: null,
//                     image: _image,
//                   ),
//                 ),
//               ),
//               firstHalf: _buildPhotoSection(context),
//               secondHalf: _buildInfoSection(context));
//         })),
//       ),
//     );
//   }

//   _buildPhotoSection(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final minLength = min(size.width, size.height);

//     return GestureDetector(
//       onTap: () => _choosePhoto(context),
//       child: (_image != null) || (imageUrl != null)
//           ? Container()
//           : Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     "Add/Upload Photo",
//                     textAlign: TextAlign.left,
//                     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                   ),
//                   Center(
//                     child: Icon(
//                       Icons.add_a_photo,
//                       color: Colors.grey,
//                       size: minLength / 5,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//     );
//   }

//   _choosePhoto(BuildContext context) async {
//     final uncroppedImageFile = await ImagePickerService.getImage(context);
//     if (uncroppedImageFile == null) {
//       return;
//     }

//     File croppedFile = await ImageCropper.cropImage(
//         sourcePath: uncroppedImageFile.path,
//         aspectRatioPresets: Platform.isAndroid
//             ? [
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio16x9
//               ]
//             : [
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio5x3,
//                 CropAspectRatioPreset.ratio5x4,
//                 CropAspectRatioPreset.ratio7x5,
//                 CropAspectRatioPreset.ratio16x9
//               ],
//         androidUiSettings: AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.deepOrange,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         iosUiSettings: IOSUiSettings(
//           title: 'Cropper',
//         ));

//     if (croppedFile != null) {
//       setState(() {
//         _image = croppedFile;
//       });
//     }
//   }

//   _buildInfoSection(BuildContext context) {
//     final length = MediaQuery.of(context).size.height;
//     final availableSpace = (length * 0.6 - 250);
//     var lines = availableSpace * 0.03;

//     return Form(
//       key: _formkey,
//       child: Padding(
//         padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     "My Details",
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white),
//                   ),
//                 ),
//                 (_image == null) && (imageUrl == null)
//                     ? Container()
//                     : IconButton(
//                         icon: Icon(
//                           Icons.add_a_photo,
//                           color: Colors.white,
//                           size: 32,
//                         ),
//                         onPressed: () => _choosePhoto(context)),
//                 SizedBox(width: 8)
//               ],
//             ),
//             SizedBox(height: 20),
//             Row(mainAxisSize: MainAxisSize.max, children: [
//               Expanded(
//                 flex: 2,
//                 child: CustomTextField(
//                   controller: _nameFieldController,
//                   placeHolderText: "Name",
//                   validator: (value) {
//                     return value.length > 0 ? null : "Enter you name.";
//                   },
//                 ),
//               ),
//               SizedBox(width: 20),
//               Expanded(
//                   child: CustomDropdownButton(
//                 labelText: age == 0 ? "Age" : "${age.toInt()} years",
//                 onPressed: () => _showAgeSelectionSheet(context),
//               ))
//             ]),
//             SizedBox(height: 20),
//             CustomTextField(
//               numberOfLines: lines.toInt(),
//               controller: _aboutFieldController,
//               placeHolderText: "Few words about me",
//               keyboardType: TextInputType.text,
//             ),
//             SizedBox(height: profile?.address == null ? 0 : 20),
//             profile?.address == null
//                 ? Container()
//                 : CustomTextField(
//                     numberOfLines: 1,
//                     controller: _addressFieldController,
//                     enabled: false,
//                     keyboardType: TextInputType.number,
//                     placeHolderText: "Address",
//                   ),
//             SizedBox(height: 20),
//             Row(mainAxisSize: MainAxisSize.max, children: [
//               profile?.selectedInterest?.heightRequired == false
//                   ? Container()
//                   : Expanded(
//                       child: CustomDropdownButton(
//                       enabled: true,
//                       labelText: "${height?.toInt()} cm",
//                       onPressed: () => _showHeightSelectionSheet(context),
//                     )),
//               (profile?.selectedInterest?.weightRequired == null)
//                   ? SizedBox(width: 20)
//                   : Container(),
//               profile?.selectedInterest?.weightRequired == false
//                   ? Container()
//                   : Expanded(
//                       child: CustomDropdownButton(
//                       enabled: true,
//                       labelText: "${weight?.toInt()} kg",
//                       onPressed: () => _showWeightSelectionSheet(context),
//                     ))
//             ]),
//           ],
//         ),
//       ),
//     );
//   }

//   _showAgeSelectionSheet(BuildContext context) {
//     _showBottomSheet(
//         context,
//         AgeSlider(
//           age: age,
//           onChanged: (value) {
//             setState(() {
//               age = value;
//             });
//           },
//         ));
//   }

//   _showHeightSelectionSheet(BuildContext context) {
//     _showBottomSheet(
//         context,
//         HeightSlider(
//           height: height,
//           onChanged: (value) {
//             setState(() {
//               height = value;
//             });
//           },
//         ));
//   }

//   _showWeightSelectionSheet(BuildContext context) {
//     _showBottomSheet(
//         context,
//         WeightSlider(
//           weight: weight,
//           onChanged: (value) {
//             setState(() {
//               weight = value;
//             });
//           },
//         ));
//   }

//   _showBottomSheet(BuildContext context, CustomSlider slider) {
//     showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         builder: (context) => Container(
//               child: Container(
//                 padding: EdgeInsets.all(32),
//                 decoration: BoxDecoration(
//                     gradient: AppGradients.backgroundGradient,
//                     borderRadius: BorderRadius.circular(8.0)),
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: <Widget>[
//                     slider,
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(top: 16, right: 16, left: 16),
//                       child: AuthRoundedButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ));
//   }

//   void _updateProfile(BuildContext context) {
//     if (_nameFieldController.text.isEmpty) {
//       CustomSnackbar.showFailed(context, "Please Enter the your name.");
//     } else if (age < PreferenceConstants.minAgeValue) {
//       CustomSnackbar.showFailed(context,
//           "You should be ${PreferenceConstants.minAgeValue.toInt()} or more to use this app.");
//     } else {
//       UserProfile profile = UserProfile(
//         name: _nameFieldController?.text,
//         age: age.toInt(),
//         height: height,
//         about: _aboutFieldController?.text,
//       );
//       BlocProvider.of<EditProfileBloc>(context, listen: false)
//           .add(UpdateUserProfileEvent(profile: profile, image: _image));
//     }
//   }
// }
