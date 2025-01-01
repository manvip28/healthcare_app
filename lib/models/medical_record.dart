import 'package:hive/hive.dart';

part 'medical_record.g.dart';

@HiveType(typeId: 2)
class MedicalRecord extends HiveObject {
  @HiveField(0)
  final String diagnosis;

  @HiveField(1)
  final List<String> prescription;

  @HiveField(2)
  final String notes;

  @HiveField(3)
  final DateTime date;

  MedicalRecord({
    required this.diagnosis,
    required this.prescription,
    required this.notes,
    required this.date,
  });
}
