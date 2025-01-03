import 'package:hive/hive.dart';
import 'vitals.dart';
import 'medical_record.dart';

part 'patient.g.dart';

@HiveType(typeId: 3)
class Patient extends HiveObject {
  @HiveField(0)
  final String id; // Patient ID

  @HiveField(1)
  final String name; // Patient name

  @HiveField(2)
  final DateTime dateOfBirth; // Patient's date of birth

  @HiveField(3)
  final List<Vitals> vitals; // List of vitals

  @HiveField(4)
  final List<MedicalRecord> records; // List of medical records

  @HiveField(5)
  final String diagnosis; // Patient's diagnosis

  Patient({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    this.vitals = const [],
    this.records = const [],
    required this.diagnosis,
  });

  // Calculate age from date of birth
  int get age {
    final currentDate = DateTime.now();
    final age = currentDate.year - dateOfBirth.year;
    if (currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month && currentDate.day < dateOfBirth.day)) {
      return age - 1;
    }
    return age;
  }
}
