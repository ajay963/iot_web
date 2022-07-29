import 'package:flutter/foundation.dart';

class TempData extends ChangeNotifier {
  // All value in celcius
  int _temp = 0;
  int _minTemp = -15;
  int _maxTemp = 150;

  int get getTemp => _temp;
  int get getMinLux => _minTemp;
  int get getMaxLux => _maxTemp;

  setMinMax() {
    if (_temp < _minTemp) _minTemp = _temp;
    if (_temp > _maxTemp) _maxTemp = _temp;
  }

  setTemp({required int temp}) {
    _temp = temp;
    notifyListeners();
  }
}

class HumidityData extends ChangeNotifier {
  // All value in celcius
  int _humidity = 0;
  int _minHumidity = -15;
  int _maxHumidity = 150;

  int get getHumidity => _humidity;
  int get getMinHumidity => _minHumidity;
  int get getMaxHumidity => _maxHumidity;

  setMinMax() {
    if (_humidity < _minHumidity) _minHumidity = _humidity;
    if (_humidity > _maxHumidity) _maxHumidity = _humidity;
  }

  setHumidity({required int humidity}) {
    _humidity = humidity;
    notifyListeners();
  }
}

class LuxData extends ChangeNotifier {
  // All value in celcius
  int _lux = 0;
  int _minLux = -15;
  int _maxLux = 150;

  int get getLux => _lux;
  int get getMinLux => _minLux;
  int get getMaxLux => _maxLux;

  setMinMax() {
    if (_lux < _minLux) _minLux = _lux;
    if (_lux > _maxLux) _maxLux = _lux;
  }

  setLux({required int lux}) {
    _lux = lux;
    notifyListeners();
  }
}
