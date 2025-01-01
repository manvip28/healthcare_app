import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/patient.dart';  // Ensure this path is correct
import '../providers/patient_provider.dart';  // Ensure this import is correct

class PatientListWidget extends StatelessWidget {
  const PatientListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Provider.of or Consumer to access PatientProvider
    return Consumer<PatientProvider>(
      builder: (context, patientProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            patientProvider.patients.isEmpty
                ? const Text('No patients available.')
                : ListView.builder(
              shrinkWrap: true,
              itemCount: patientProvider.patients.length,
              itemBuilder: (context, index) {
                final patient = patientProvider.patients[index];
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text('Age: ${patient.age}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/patient-details',
                      arguments: patient.id,
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
