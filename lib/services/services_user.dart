import 'package:flutter/material.dart';

class ServicesUser extends ChangeNotifier {
  
  String serviceName;
  String serviceDescription;

  ServicesUser({
    required this.serviceName,
    required this.serviceDescription,
  });

  void updateService(String newName, String newDescription) {
    serviceName = newName;
    serviceDescription = newDescription;
    notifyListeners();
  }
}