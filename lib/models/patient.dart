import 'package:hive/hive.dart';
import 'vitals.dart';
import 'medical_record.dart';

part 'patient.g.dart';

@HiveType(typeId: 0)
class Patient extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  List<Vitals> vitals;

  @HiveField(4)
  List<MedicalRecord> records;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    this.vitals = const [],
    this.records = const [],
  });
}
