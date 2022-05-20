import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class NetworkData {
  String networkData({required ConnectivityResult networkResult}) {
    switch (networkResult) {
      case ConnectivityResult.mobile:
        return 'Mobile Connection';

      case ConnectivityResult.wifi:
        return 'Wi-Fi Connection';

      case ConnectivityResult.ethernet:
        return 'Ethernet Connection';

      default:
        return 'No Connection';
    }
  }
}

class InternetCheckerClass extends ChangeNotifier {
  bool _hasInternet = false;
  ConnectivityResult _networkType = ConnectivityResult.none;
  bool get getInternetStatua => _hasInternet;
  ConnectivityResult get getNetworkType => _networkType;

  void setInternetStatus(bool hasInternet) {
    _hasInternet = hasInternet;
    notifyListeners();
  }

  void setNetworkType(ConnectivityResult networkType) {
    _networkType = networkType;
    notifyListeners();
  }
}
