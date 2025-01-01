

import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import '../models/vitals.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  Stream<Vitals> get vitalsStream async* {
    await for (final accel in accelerometerEvents) {
      final heartRate = _calculateHeartRate(accel);
      final temp = await _estimateTemperature();

      yield Vitals(
        heartRate: heartRate,
        bloodPressure: '120/80', // Placeholder
        temperature: temp,
        timestamp: DateTime.now(),
      );
    }
  }

  int _calculateHeartRate(AccelerometerEvent event) {
    final magnitude = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
    return 60 + (magnitude * 10).round();
  }

  Future<double> _estimateTemperature() async {
    // Simplified temperature estimation
    return 36.5 + Random().nextDouble();
  }
}
