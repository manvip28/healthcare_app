import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:healthcare_app/models/patient.dart';
import 'package:healthcare_app/models/medical_record.dart';

part 'appointment.g.dart';

@HiveType(typeId: 5)  // Using typeId 5 since 2 and 3 are used by MedicalRecord and Patient
class Appointment extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String patientId;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String purpose;

  @HiveField(4)
  final bool isNotified;

  Appointment({
    required this.id,
    required this.patientId,
    required this.dateTime,
    required this.purpose,
    this.isNotified = false,
  });
}
