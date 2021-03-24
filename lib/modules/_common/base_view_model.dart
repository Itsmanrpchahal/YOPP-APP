import 'package:flutter/material.dart';

enum ServiceStatus { none, loading, success, failure }

abstract class BaseViewModel extends ChangeNotifier {
  String displayMessage;
  ServiceStatus serviceStatus = ServiceStatus.none;

  displayLoading([String message = "Loading.."]) {
    displayMessage = message;
    serviceStatus = ServiceStatus.loading;
    notifyListeners();
  }

  displayFailure([String message = "Failed"]) {
    displayMessage = message;
    serviceStatus = ServiceStatus.failure;
    notifyListeners();
  }

  displaySuccess([String message = "Success"]) {
    displayMessage = message;
    serviceStatus = ServiceStatus.success;
    notifyListeners();
  }
}
