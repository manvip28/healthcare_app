import 'package:hive/hive.dart';
import '../models/patient.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<void> savePatient(Patient patient) async {
    final box = await Hive.openBox<Patient>('patients');
    await box.put(patient.id, patient);
  }

  Future<List<Patient>> getAllPatients() async {
    final box = await Hive.openBox<Patient>('patients');
    return box.values.toList();
  }
}