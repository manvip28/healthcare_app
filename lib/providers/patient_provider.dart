import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:healthcare_app/models/patient.dart';
import 'package:healthcare_app/models/vitals.dart';
import 'package:healthcare_app/models/medical_record.dart';

class PatientProvider with ChangeNotifier {
  List<Patient> patients = [];
  List<Vitals> vitals = [];
  List<MedicalRecord> records = [];

  // Flag to check if vitals are loaded
  bool vitalsLoaded = false;

  // Load all patients from Hive
  Future<void> loadPatients() async {
    var box = await Hive.openBox<Patient>('patients');
    patients = box.values.toList();
    notifyListeners();
  }

  // Load vitals from Hive
  Future<void> loadVitals() async {
    if (vitalsLoaded) return;  // Prevent reloading if already loaded

    try {
      var box = await Hive.openBox<Vitals>('vitals');
      vitals = box.values.toList();
      vitalsLoaded = true;
      print("Vitals loaded: ${vitals.length}");
      notifyListeners();
    } catch (e) {
      print("Error loading vitals: $e");
      // Reset the flag in case of error to allow retry
      vitalsLoaded = false;
    }
  }

  // Load medical records from Hive
  Future<void> loadRecords() async {
    var box = await Hive.openBox<MedicalRecord>('records');
    records = box.values.toList();
    notifyListeners();
  }

  // Add a new vital for a specific patient
  Future<void> addVitalsForPatient(Patient patient, Vitals vital) async {
    try {
      // Open both boxes
      var patientBox = await Hive.openBox<Patient>('patients');
      var vitalsBox = await Hive.openBox<Vitals>('vitals');

      // Add the vital to the vitals box
      await vitalsBox.add(vital);

      // Add the new vital to the patient's vitals list
      patient.vitals.add(vital);

      // Update the patient's record in the box
      await patientBox.put(patient.id, patient);

      // Update the local lists
      vitals.add(vital);

      print("Vital added successfully. Total vitals: ${vitals.length}");

      // Notify listeners so the UI gets updated
      notifyListeners();
    } catch (e) {
      print("Error adding vital: $e");
      throw Exception("Failed to save vital signs");
    }
  }

  // Add a new medical record
  Future<void> addMedicalRecord(MedicalRecord record) async {
    var box = await Hive.openBox<MedicalRecord>('records');
    await box.add(record);
    records.add(record);
    notifyListeners();
  }

  // Add a new patient
  void addPatient(Patient patient) {
    patients.add(patient);
    notifyListeners();
  }

  // Get a patient by ID
  Patient getPatient(String patientId) {
    return patients.firstWhere((patient) => patient.id == patientId);
  }

  // Get vitals for a specific patient
  List<Vitals> getVitalsForPatient(String patientId) {
    return vitals.where((vital) => vital.patientId == patientId).toList();
  }

  // Clear and reload vitals
  Future<void> refreshVitals() async {
    vitalsLoaded = false;
    vitals.clear();
    await loadVitals();
  }

  // Getter for patients list
  List<Patient> get patientsList => patients;

  // Getter for vitals list
  List<Vitals> get vitalsList => vitals;

  // Method to check if vitals are loaded
  bool areVitalsLoaded() => vitalsLoaded;
}