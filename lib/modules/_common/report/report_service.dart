import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:yopp/helper/url_constants.dart';

abstract class ReportService {
  Future<void> reportUser(
    String reportBy,
    String reportTo,
    String title,
    String subject,
    String description,
  );
}

class ApiReportService extends ReportService {
  @override
  Future<void> reportUser(String reportBy, String reportTo, String title,
      String subject, String description) async {
    try {
      var url = UrlConstants.reportUser;
      var response = await http.post(url, body: {
        'report_by': reportBy,
        'report_to': reportTo,
        'title': title,
        'subject': subject,
        'description': description
      });

      if (response.statusCode == 201) {
        return;
      } else {
        FirebaseCrashlytics.instance.log("event is reportUser API call");
        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: Exception(response)));
        throw Exception('Failed to report user.');
      }
    } on TimeoutException catch (e) {
      // print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      // print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("event is reportUser API call");
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));
      // print("error: " + error.toString());
      throw error;
    }
  }
}
