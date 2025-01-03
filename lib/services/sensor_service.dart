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
      final bloodSugar = _estimateBloodSugar();

      // Initialize empty symptoms maps
      final heartAttackSymptoms = {
        'Chest Pain': false,
        'Shortness of Breath': false,
        'Cold Sweat': false,
        'Nausea': false,
        'Jaw/Back Pain': false,
      };

      final hypoglycemicSymptoms = {
        'Confusion': false,
        'Weakness': false,
        'Dizziness': false,
        'Trembling': false,
        'Rapid Heartbeat': false,
      };

      yield Vitals(
        patientId: '123',
        heartRate: heartRate,
        bloodPressure: '120/80', // Placeholder
        bloodSugar: bloodSugar,
        temperature: temp,
        timestamp: DateTime.now(),
        heartAttackSymptoms: heartAttackSymptoms,
        hypoglycemicSymptoms: hypoglycemicSymptoms,
        duration: 'N/A', // Default duration for sensor readings
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

  String _estimateBloodSugar() {
    // Simplified blood sugar estimation (70-140 mg/dL is typically normal range)
    return '${70 + Random().nextInt(71)}'; // Returns a value between 70-140
  }
}