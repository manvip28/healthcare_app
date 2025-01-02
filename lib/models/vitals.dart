import 'package:hive/hive.dart';

part 'vitals.g.dart';

@HiveType(typeId: 4)
class Vitals extends HiveObject {
  @HiveField(0)
  final String patientId;

  @HiveField(1)
  final int heartRate;

  @HiveField(2)
  final String bloodPressure;

  @HiveField(3)
  final String bloodSugar;

  @HiveField(4)
  final double temperature;

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  final Map<String, bool> heartAttackSymptoms;

  @HiveField(7)
  final Map<String, bool> hypoglycemicSymptoms;

  @HiveField(8)
  final String duration;

  Vitals({
    required this.patientId,
    required this.heartRate,
    required this.bloodPressure,
    required this.bloodSugar,
    required this.temperature,
    required this.timestamp,
    required this.heartAttackSymptoms,
    required this.hypoglycemicSymptoms,
    required this.duration,
  });
}
