import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:healthcare_app/models/patient.dart';
import 'package:healthcare_app/models/vitals.dart';
import 'package:healthcare_app/models/medical_record.dart';
import '../models/appointment.dart';
import '../services/notification_service.dart';

class PatientProvider with ChangeNotifier {
  final NotificationService _notificationService;

  List<Patient> patients = [];
  List<Vitals> vitals = [];
  List<MedicalRecord> records = [];
  final List<Appointment> _appointments = [];

  PatientProvider({
    required NotificationService notificationService,
  }) : _notificationService = notificationService {
    loadAppointments();  // Load appointments when the provider is initialized
  }

  List<Appointment> get appointments => _appointments;

  // Add an appointment and save to Hive
  Future<void> addAppointment(Appointment appointment) async {
    _appointments.add(appointment);

    // Save to Hive
    final box = await Hive.openBox<Appointment>('appointments');
    await box.add(appointment);

    // Schedule notification
    try {
      final patient = getPatient(appointment.patientId);
      await _notificationService.scheduleAppointmentNotification(
        patient.name,
        appointment.dateTime,
        appointment.purpose,
      );
    } catch (e) {
      debugPrint('Failed to schedule notification: $e');
    }

    notifyListeners();  // Notify listeners after adding
  }

  // Load appointments from Hive
  Future<void> loadAppointments() async {
    final box = await Hive.openBox<Appointment>('appointments');
    _appointments.clear();  // Clear the old list
    _appointments.addAll(box.values);
    notifyListeners();  // Notify listeners after loading appointments
  }

  // Get patient appointments
  List<Appointment> getPatientAppointments(String patientId) {
    return _appointments
        .where((appointment) => appointment.patientId == patientId)
        .toList();
  }

  // Get next appointment for a patient
  Appointment? getNextAppointment(String patientId) {
    final patientAppointments = getPatientAppointments(patientId)
        .where((appointment) => appointment.dateTime.isAfter(DateTime.now()))
        .toList();
    patientAppointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return patientAppointments.isNotEmpty ? patientAppointments.first : null;
  }

  // Delete an appointment
  Future<void> deleteAppointment(Appointment appointment) async {
    _appointments.remove(appointment);

    // Remove from Hive
    final box = await Hive.openBox<Appointment>('appointments');
    try {
      final appointmentToDelete = box.values.firstWhere(
            (a) => a.id == appointment.id,
      );
      await appointmentToDelete.delete();

      // Cancel notification
      await _notificationService.cancelNotification(
        appointment.dateTime.millisecondsSinceEpoch ~/ 1000,
      );
    } catch (e) {
      debugPrint('Failed to delete appointment: $e');
    }

    notifyListeners();  // Notify listeners after deleting
  }

  // Update an appointment
  Future<void> updateAppointment(Appointment oldAppointment, Appointment newAppointment) async {
    final index = _appointments.indexWhere((a) => a.id == oldAppointment.id);
    if (index != -1) {
      _appointments[index] = newAppointment;

      // Update in Hive
      final box = await Hive.openBox<Appointment>('appointments');
      try {
        final appointmentToUpdate = box.values.firstWhere(
              (a) => a.id == oldAppointment.id,
        );
        final key = appointmentToUpdate.key;
        await box.put(key, newAppointment);

        // Cancel old notification and schedule new one
        await _notificationService.cancelNotification(
          oldAppointment.dateTime.millisecondsSinceEpoch ~/ 1000,
        );

        final patient = getPatient(newAppointment.patientId);
        await _notificationService.scheduleAppointmentNotification(
          patient.name,
          newAppointment.dateTime,
          newAppointment.purpose,
        );
      } catch (e) {
        debugPrint('Failed to update appointment: $e');
      }

      notifyListeners();  // Notify listeners after updating
    }
  }

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
      print("Vitals loaded:${vitals.length}");
      notifyListeners();
    } catch (e) {
      print("Error loading vitals: \$e");
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

      print("Vital added successfully. Total vitals: \${vitals.length}");

      // Notify listeners so the UI gets updated
      notifyListeners();
    } catch (e) {
      print("Error adding vital: \$e");
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
