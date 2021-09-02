import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:yopp/helper/url_constants.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/api_connection_data.dart';

abstract class ConnectionService {
  Future<bool> addConnection(
      {@required String friendID,
      @required String friendInterest,
      @required String myID,
      @required String myInterest,
      @required String connectionId});

  Future<UserConnection> loadConnections({
    @required String uid,
    int skipto = 0,
    int limit = 20,
  });

  Future<bool> deleteConnection({
    @required List<String> uids,
    @required String connectionId,
  });
}

class ApiConnectionService extends ConnectionService {
  @override
  Future<bool> addConnection({
    String friendID,
    String friendInterest,
    String myID,
    String myInterest,
    String connectionId,
  }) async {
    try {
      var url = UrlConstants.connections;

      Map data = {
        "connectionId": connectionId,
        "friendID": friendID,
        "friendInterest": friendInterest,
        "myID": myID,
        "myInterest": myInterest,
      };

      String body = json.encode(data);

      print("addConnection :" + body);

      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print("Success");
        print('Response body: ${response.body}');
        print('Response status: ${response.statusCode}');
        return true;
      } else {
        print(response.request.toString());
        FirebaseCrashlytics.instance.log("addConnection");
        FirebaseCrashlytics.instance.log(response.body.toString());
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: Exception("addConnection")));
        throw Exception('Failed to create connection.');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error) {
      print("error: " + error.toString());
      FirebaseCrashlytics.instance.log("addConnection");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));
      throw error;
    }
  }

  @override
  Future<UserConnection> loadConnections({
    String uid,
    int skipto = 0,
    int limit = 20,
  }) async {
    try {
      var url = UrlConstants.loadconnections;

      Map data = {
        "limit": limit,
        "uid": uid,
        "skipto": skipto,
      };

      String body = json.encode(data);

      print("loadConnections :" + body);

      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201) {
        print('Response status: ${response.statusCode}');

        print('Response body: ${response.body}');
        final data = UserConnection.fromJson(response.body);
        print("Response data: " + data.toJson());
        return data;
      } else {
        FirebaseCrashlytics.instance.log("loadConnections");
        FirebaseCrashlytics.instance.log(response.body.toString());
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: Exception("loadConnections")));
        throw Exception('Failed to load connections.');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error) {
      print("error: " + error);
      FirebaseCrashlytics.instance.log("loadConnections");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));
      throw error;
    }
  }

  @override
  Future<bool> deleteConnection(
      {List<String> uids, String connectionId}) async {
    try {
      final url = Uri.parse(UrlConstants.connections);
      final request = http.Request("DELETE", url);
      request.headers.addAll(<String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8'
      });
      request.body = jsonEncode({"id": connectionId, "uid": uids});
      final response = await request.send();

      if (response.statusCode == 200) {
        print("deleteConnection  success");
        final body = await response.stream.bytesToString();
        print(body);
        // return UserProfile.fromJson(jsonDecode(body));
        return true;
      } else {
        print(response.request.toString());
        print(response.request.toString());
        FirebaseCrashlytics.instance.log("deleteConnection");

        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: Exception("deleteConnection")));
        throw Exception('Failed to Delete Connection.');
      }
    } catch (error) {
      print("error: " + error.toString());
      FirebaseCrashlytics.instance.log("deleteConnection");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: error));
      throw error;
    }
  }
}
