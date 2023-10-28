import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../screens/internet_lose_screen.dart';

class InternetController extends GetxController {
  StreamSubscription? streamSubscription;
  Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> checkRealtimeConnection() {
    return connectivity.onConnectivityChanged.listen((event) async {
      if (event == ConnectivityResult.mobile) {
        debugPrint("Connected to MobileData");
        Fluttertoast.showToast(
          msg: "Connected to MobileData",
          backgroundColor: Colors.green,
        );
        update();
      } else if (event == ConnectivityResult.wifi) {
        debugPrint("Connected to Wifi");
        Fluttertoast.showToast(
          msg: "Connected to Wifi",
          backgroundColor: Colors.green,
        );
        update();
      } else {
        debugPrint("Offline");
        Get.to(() => const InternetLoseScreen());
        Fluttertoast.showToast(
          msg: "Internet connection lose!",
          backgroundColor: Colors.red,
        );
        update();
      }
      update();
    });
  }

  StreamSubscription<ConnectivityResult> connectionRetry() {
    return connectivity.onConnectivityChanged.listen((event) async {
      if (event == ConnectivityResult.mobile) {
        Fluttertoast.showToast(
          msg: "Connected to MobileData",
          backgroundColor: Colors.green,
        );
        update();
        Get.back();
      } else if (event == ConnectivityResult.wifi) {
        debugPrint("Connected to Wifi");
        Fluttertoast.showToast(
          msg: "Connected to Wifi",
          backgroundColor: Colors.green,
        );
        Get.back();
        update();
      } else if (event == ConnectivityResult.none) {
        debugPrint("Offline");
        Fluttertoast.showToast(
          msg: "Internet connection lose!",
          backgroundColor: Colors.red,
        );
        update();
      }
      update();
    });
  }
}
