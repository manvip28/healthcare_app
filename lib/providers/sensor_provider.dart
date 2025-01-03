import 'package:flutter/foundation.dart';
import '../services/sensor_service.dart';
import '../models/vitals.dart';

class SensorProvider with ChangeNotifier {
  final SensorService _sensorService = SensorService();
  final List<Vitals> _vitalsHistory = [];

  Stream<Vitals> get vitalsStream => _sensorService.vitalsStream;
  List<Vitals> get vitalsHistory => _vitalsHistory;

  void addVitalsReading(Vitals vitals) {
    _vitalsHistory.add(vitals);
    if (_vitalsHistory.length > 100) {
      _vitalsHistory.removeAt(0);
    }
    notifyListeners();
  }
}
