import 'package:flutter/material.dart';
import 'package:healthcare_app/screens/add_patient_page.dart';
import 'package:healthcare_app/screens/patient_details_page.dart';
import 'screens/home_page.dart'; // Ensure this import is correct

class HealthcareApp extends StatelessWidget {
  const HealthcareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(), // Set HomePage as the initial screen
      routes: {
        '/add-patient': (context) => AddPatientPage(),
        '/patient-details': (context) {
          // Extract the patientId argument passed from the previous page
          final patientId = ModalRoute.of(context)!.settings.arguments as String;
          return PatientDetailsPage(patientId: patientId); // Pass patientId as argument
        },
      },
    );
  }
}
