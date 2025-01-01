import 'package:hive/hive.dart';

part 'vitals.g.dart';

@HiveType(typeId: 1)
class Vitals extends HiveObject {
  @HiveField(0)
  final int heartRate;

  @HiveField(1)
  final String bloodPressure;

  @HiveField(2)
  final double temperature;

  @HiveField(3)
  final DateTime timestamp;

  Vitals({
    required this.heartRate,
    required this.bloodPressure,
    required this.temperature,
    required this.timestamp,
  });
}
