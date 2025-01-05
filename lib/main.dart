import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'models/appointment.dart';
import 'providers/patient_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/auth_provider.dart';
import 'models/patient.dart';
import 'models/vitals.dart';
import 'models/medical_record.dart';
import 'models/attachment.dart'; // Import the new attachment model file
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Future<void> requestNotificationPermission() async {
    final permissionStatus = await Permission.notification.status;

    if (permissionStatus.isDenied) {
      // Request permission if denied
      await Permission.notification.request();
    } else if (permissionStatus.isPermanentlyDenied) {
      // Show a dialog or toast notifying the user that they must enable notification permissions from settings
      print("Notification permission is permanently denied. Please enable it from settings.");
    }
  }

  Future<void> resetHiveData() async {
    try {
      await Hive.deleteBoxFromDisk('patients');
      await Hive.deleteBoxFromDisk('medical_records');
      await Hive.deleteBoxFromDisk('attachments');
      await Hive.deleteBoxFromDisk('vitals');
      await Hive.deleteBoxFromDisk('appointments');  // Add this line to delete the appointments box
      print("All Hive boxes have been deleted successfully.");
    } catch (e) {
      print("Error deleting Hive boxes: $e");
    }
  }

  // Initialize Hive and open the necessary boxes
  await Hive.initFlutter();

  // Register the adapters for Hive
  await initHiveAdapters();

  // Delete Hive data if needed (Uncomment when required)
  await resetHiveData();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Request notification permission when the app starts
  await requestNotificationPermission();

  runApp(
    MultiProvider(
      providers: [
        // Providing the necessary providers
        ChangeNotifierProvider(create: (_) => PatientProvider(notificationService: notificationService)..loadVitals()), // Call loadVitals here
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const HealthcareApp(),
    ),
  );
}

Future<void> initHiveAdapters() async {
  try {
    // Registering adapters for all models
    Hive.registerAdapter(PatientAdapter());
    Hive.registerAdapter(VitalsAdapter());
    Hive.registerAdapter(MedicalRecordAdapter());
    Hive.registerAdapter(AttachmentAdapter());  // Ensure AttachmentAdapter is registered
    Hive.registerAdapter(AppointmentAdapter()); // Register the AppointmentAdapter

    // Open the boxes concurrently
    await Future.wait([
      Hive.openBox<Patient>('patients'),
      Hive.openBox<MedicalRecord>('medical_records'),
      Hive.openBox<Attachment>('attachments'),  // Ensure you open the box for attachments
      Hive.openBox<Vitals>('vitals'),  // Add this to open the vitals box
      Hive.openBox<Appointment>('appointments'), // Ensure you open the box for appointments
    ]);
  } catch (e) {
    print("Error initializing Hive: $e");
  }
}
