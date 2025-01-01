import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/patient.dart';

class PatientProvider with ChangeNotifier {
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  // Load all patients from the Hive box
  Future<void> loadPatients() async {
    final box = await Hive.openBox<Patient>('patients');
    _patients = box.values.toList();
    notifyListeners();
  }

  // Add a new patient to the Hive box
  Future<void> addPatient(Patient patient) async {
    final box = await Hive.openBox<Patient>('patients');
    await box.add(patient);
    _patients.add(patient);
    notifyListeners();
  }

  // Fetch a patient by ID
  Patient getPatient(String id) {
    return _patients.firstWhere((p) => p.id == id);
  }
}
