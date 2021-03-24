import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/model.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/helper/firebase_constants.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/api_profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

import 'profile_service.dart';
import 'user_sport.dart';

class FirebaseProfileService extends ProfileService {
  @override
  Future<void> deleteProfile(String userId) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      await updateProfile(UserProfile(status: UserStatus.deleted));
      FirebaseConstants.userCollectionRef
          .doc(userId)
          .collection('sports')
          .get()
          .then((value) async {
        for (DocumentSnapshot doc in value.docs) {
          await doc.reference.delete();
        }
      });

      await ApiProfileService().updateProfile(UserProfile(
        uid: userId,
        status: UserStatus.deleted,
      ));
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("deleteProfile");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("deleteProfile");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<UserProfile> addUserProfile(UserProfile profile) async {
    final userId = FirebaseAuth.instance.currentUser.uid;

    try {
      final id = await ApiProfileService().addUserProfile(profile);
      final data = profile.copyWith(id: id);
      await FirebaseConstants.userCollectionRef.doc(userId).set(
            data.toJson(),
          );
      return data;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("addUserProfile");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("addUserProfile");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<void> saveGender(Gender gender) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      var update = UserProfile(uid: userId, gender: gender);
      await updateProfile(update);
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("saveGender");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(gender.name);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("saveGender");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(gender.name);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<void> saveDOB(int year) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      await FirebaseConstants.userCollectionRef
          .doc(userId)
          .set({'dob': year}, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("saveDOB");
      FirebaseCrashlytics.instance.log(year.toString());
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("saveDOB");
      FirebaseCrashlytics.instance.log(year.toString());
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    final userId = FirebaseAuth.instance.currentUser.uid;

    try {
      print("Update:" + profile.toJson().toString());

      await ApiProfileService().updateProfile(profile.copyWith(uid: userId));
      await FirebaseConstants.userCollectionRef
          .doc(userId)
          .set(profile.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("updateProfile");
      FirebaseCrashlytics.instance.log(profile.toJson().toString());
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("updateProfile");
      FirebaseCrashlytics.instance.log(profile.toJson().toString());
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));
      print(error.toString());
      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<UserProfile> getupdateProfile(String userId) async {
    final selectedUserId = userId ?? FirebaseAuth.instance.currentUser.uid;

    try {
      final snapshot =
          await FirebaseConstants.userCollectionRef.doc(selectedUserId).get();
      if (snapshot.exists) {
        final profile = UserProfile.fromJson(snapshot.data());
        print(snapshot.data());
        return profile;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getupdateProfile");
      FirebaseCrashlytics.instance.log(selectedUserId);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("getupdateProfile");
      FirebaseCrashlytics.instance.log(selectedUserId);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));
      print(error.toString());
      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<String> uploadProfilePhoto(File file) async {
    try {
      final userId = FirebaseAuth.instance.currentUser.uid;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("yopp")
          .child(userId)
          .child('/profile.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("uploadProfilePhoto");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("uploadProfilePhoto");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<void> saveAddress(Address address) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      await ApiProfileService()
          .updateProfile(UserProfile(uid: userId, address: address));

      final userRef = FirebaseConstants.userCollectionRef.doc(userId);
      await userRef.set({
        "address": address.toMap(),
      }, SetOptions(merge: true)).timeout(AppConstant.NETWORK_TIMEOUT_SECONDS);
    } on TimeoutException catch (e) {
      FirebaseCrashlytics.instance.log("saveAddress");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(address.toMap().toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw ErrorDescription(
          "There was error connecting to the server. Try Again");
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("saveAddress");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(address.toMap().toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw ErrorDescription(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("saveAddress");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(address.toMap().toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<List<UserSport>> getUserSports(String userId) async {
    final selectedUserId = userId ?? FirebaseAuth.instance.currentUser.uid;
    try {
      final snapshot = await FirebaseConstants.userCollectionRef
          .doc(selectedUserId)
          .collection('sports')
          .get();
      final sports =
          snapshot.docs.map((e) => UserSport.fromJson(e.data())).toList();

      return sports;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getUserSports");
      FirebaseCrashlytics.instance.log(selectedUserId);

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("getUserSports");
      FirebaseCrashlytics.instance.log(selectedUserId);

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<void> setSelectedSport({
    @required UserSport sport,
    @required UserProfile userProfile,
  }) async {
    try {
      final profileToUpdate = UserProfile(
        uid: userProfile.uid,
        selectedSport: sport,
        searchBy: sport.name + "-" + userProfile.id,
      );
      await ApiProfileService().updateProfile(profileToUpdate);

      WriteBatch batch = FirebaseFirestore.instance.batch();
      final userDocRef =
          FirebaseConstants.userCollectionRef.doc(userProfile.uid);
      batch.update(userDocRef, profileToUpdate.toJson());
      await batch.commit();
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("setSelectedSport");
      FirebaseCrashlytics.instance.log(sport.toJson().toString());
      FirebaseCrashlytics.instance.log(userProfile.toJson().toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("setSelectedSport");
      FirebaseCrashlytics.instance.log(sport.toJson().toString());
      FirebaseCrashlytics.instance.log(userProfile.toJson().toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<void> removeSportActivity(String sportName) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      final doc = FirebaseConstants.userCollectionRef
          .doc(userId)
          .collection("sports")
          .doc(sportName);

      batch.delete(doc);

      await batch.commit();
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("removeSportActivity");
      FirebaseCrashlytics.instance.log(userId);
      FirebaseCrashlytics.instance.log(sportName);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("removeSportActivity");
      FirebaseCrashlytics.instance.log(userId);
      FirebaseCrashlytics.instance.log(sportName);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<void> saveSportAcitivy({
    UserSport sport,
    double height,
    double weight,
  }) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final sportRef = FirebaseConstants.userCollectionRef
          .doc(userId)
          .collection('sports')
          .doc(sport.name);
      batch.set(sportRef, sport.toJson(), SetOptions(merge: true));

      if (height != null || weight != null) {
        await ApiProfileService().updateProfile(
            UserProfile(uid: userId, height: height, weight: weight));

        final userDocRef = FirebaseConstants.userCollectionRef.doc(userId);
        final profileToUpdate = UserProfile(height: height, weight: weight);
        batch.update(userDocRef, profileToUpdate.toJson());
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("removeSportActivity");
      FirebaseCrashlytics.instance.log(userId);
      FirebaseCrashlytics.instance.log(sport.toJson().toString());
      FirebaseCrashlytics.instance.log(height?.toString() ?? "height-null");
      FirebaseCrashlytics.instance.log(weight?.toString() ?? "weight-null");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("removeSportActivity");
      FirebaseCrashlytics.instance.log(userId);
      FirebaseCrashlytics.instance.log(sport.toJson().toString());
      FirebaseCrashlytics.instance.log(height?.toString() ?? "height-null");
      FirebaseCrashlytics.instance.log(weight?.toString() ?? "weight-null");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<void> saveAndSetSelectedSportAcitivy({
    @required UserProfile userProfile,
    @required UserSport sport,
    double height,
    double weight,
  }) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      final profileToUpdate = UserProfile(
        uid: userProfile.uid,
        selectedSport: sport,
        searchBy: sport.name + "-" + userProfile.id,
        height: height,
        weight: weight,
      );

      await ApiProfileService().updateProfile(profileToUpdate);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      final sportRef = FirebaseConstants.userCollectionRef
          .doc(userId)
          .collection('sports')
          .doc(sport.name);
      batch.set(sportRef, sport.toJson(), SetOptions(merge: true));

      final userDocRef = FirebaseConstants.userCollectionRef.doc(userId);
      batch.update(userDocRef, profileToUpdate.toJson());

      await batch.commit();
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("saveAndSetSelectedSportAcitivy");
      FirebaseCrashlytics.instance.log(userProfile.toJson().toString());
      FirebaseCrashlytics.instance.log(sport.toJson().toString());
      FirebaseCrashlytics.instance.log(height?.toString() ?? "height-null");
      FirebaseCrashlytics.instance.log(weight?.toString() ?? "weight-null");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("saveAndSetSelectedSportAcitivy");
      FirebaseCrashlytics.instance.log(userProfile.toJson().toString());
      FirebaseCrashlytics.instance.log(sport.toJson().toString());
      FirebaseCrashlytics.instance.log(height?.toString() ?? "height-null");
      FirebaseCrashlytics.instance.log(weight?.toString() ?? "weight-null");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  Future<void> blockProfile({@required String uid, @required String id}) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final myUid = FirebaseAuth.instance.currentUser.uid;
      await ApiProfileService().blockUser(uid: myUid, id: id);

      batch.update(FirebaseConstants.userCollectionRef.doc(myUid), {
        "blocked": FieldValue.arrayUnion([uid])
      });

      batch.update(FirebaseConstants.userCollectionRef.doc(uid), {
        "blockedBy": FieldValue.arrayUnion([myUid])
      });

      await batch.commit();
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("blockProfile");
      FirebaseCrashlytics.instance.log(uid);
      FirebaseCrashlytics.instance.log(id);

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("blockProfile");
      FirebaseCrashlytics.instance.log(uid);
      FirebaseCrashlytics.instance.log(id);

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<UserSport> getUserSport(String sportName) async {
    final selectedUserId = FirebaseAuth.instance.currentUser.uid;
    try {
      final snapshot = await FirebaseConstants.userCollectionRef
          .doc(selectedUserId)
          .collection('sports')
          .doc(sportName)
          .get();
      final sports = UserSport.fromJson(snapshot.data());

      return sports;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getUserSport");
      FirebaseCrashlytics.instance.log(selectedUserId);
      FirebaseCrashlytics.instance.log(sportName);

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    } catch (error) {
      FirebaseCrashlytics.instance.log("getUserSport");
      FirebaseCrashlytics.instance.log(selectedUserId);
      FirebaseCrashlytics.instance.log(sportName);

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));

      throw ErrorDescription(error.toString());
    }
  }
}
