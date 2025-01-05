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
  final int age; // Patient's age

  @HiveField(3)
  final String gender; // Patient's age

  @HiveField(4)
  final List<Vitals> vitals; // List of vitals

  @HiveField(5)
  final List<MedicalRecord> records; // List of medical records

  @HiveField(6)
  final String diagnosis; // Patient's diagnosis

  @HiveField(7)
  final String? medicalHistory; // Medical history (Optional)

  @HiveField(8)
  final String? allergies; // Allergies (Optional)

  @HiveField(9)
  final String? familyMedicalHistory; // Family medical history (Optional)

  @HiveField(10)
  final String? medications; // Medications (Optional)

  @HiveField(11)
  final String? ongoingTreatments; // Ongoing treatments (Optional)

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.vitals = const [],
    this.records = const [],
    required this.diagnosis,
    this.medicalHistory,  // Optional
    this.allergies,  // Optional
    this.familyMedicalHistory,  // Optional
    this.medications,  // Optional
    this.ongoingTreatments,  // Optional
  });
}
