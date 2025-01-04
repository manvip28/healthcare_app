import 'package:hive/hive.dart';
import 'attachment.dart';  // Import the Attachment class

part 'medical_record.g.dart';

@HiveType(typeId: 2)
class MedicalRecord extends HiveObject {
  @HiveField(0)
  final String patientId;  // New field for patientId

  @HiveField(1)
  final String diagnosis;

  @HiveField(2)
  final List<String> prescription;

  @HiveField(3)
  final String notes;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final List<Attachment> attachments;

  MedicalRecord({
    required this.patientId,  // Include patientId in the constructor
    required this.diagnosis,
    required this.prescription,
    required this.notes,
    required this.date,
    this.attachments = const [],
  });

  // Adding copyWith method
  MedicalRecord copyWith({
    String? patientId,
    String? diagnosis,
    List<String>? prescription,
    String? notes,
    DateTime? date,
    List<Attachment>? attachments,
  }) {
    return MedicalRecord(
      patientId: patientId ?? this.patientId,
      diagnosis: diagnosis ?? this.diagnosis,
      prescription: prescription ?? this.prescription,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      attachments: attachments ?? this.attachments,
    );
  }
}

