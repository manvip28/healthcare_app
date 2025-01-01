import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // Import this package
import 'app.dart';
import 'providers/patient_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/auth_provider.dart';
import 'models/patient.dart';
import 'models/vitals.dart';
import 'models/medical_record.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open the box for settings
  await Hive.initFlutter();
  await Hive.openBox('settings');

  // Register the adapters for Hive
  await initHiveAdapters();

  // Request notification permission when app starts
  await requestNotificationPermission();

  runApp(
    MultiProvider(
      providers: [
        // Providing the necessary providers
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const HealthcareApp(),
    ),
  );
}

// Function to initialize Hive adapters
Future<void> initHiveAdapters() async {
  Hive.registerAdapter(PatientAdapter());
  Hive.registerAdapter(VitalsAdapter());
  Hive.registerAdapter(MedicalRecordAdapter());

  // Open the 'patients' box to store the patient data
  await Hive.openBox<Patient>('patients');
}

// Function to request notification permission
Future<void> requestNotificationPermission() async {
  // Check and request the notification permission if not granted
  if (await Permission.notification.isDenied) {
    // Request permission
    await Permission.notification.request();
  }
}
