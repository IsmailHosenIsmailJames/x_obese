import "dart:developer";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:dio/dio.dart" as dio;
import "package:fluttertoast/fluttertoast.dart";

Future<bool> checkConnectivity() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
    return true;
  } else {
    return false;
  }
}

void showToastMessageFromResponse(dio.Response response) {
  try {
    String message = response.data["message"] ?? "";
    Fluttertoast.showToast(msg: message);
  } catch (e) {
    log(e.toString(), name: "error_message");
  }
}
