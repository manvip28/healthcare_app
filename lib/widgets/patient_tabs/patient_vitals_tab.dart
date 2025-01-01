// lib/widgets/patient_tabs/patient_vitals_tab.dart
import 'package:flutter/material.dart';
import '../../models/patient.dart';

class PatientVitalsTab extends StatelessWidget {
  final Patient patient;

  const PatientVitalsTab({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: patient.vitals.length,
      itemBuilder: (context, index) {
        final vital = patient.vitals[index];
        return Card(
          child: ListTile(
            title: Text('Heart Rate: ${vital.heartRate} BPM'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BP: ${vital.bloodPressure}'),
                Text('Temp: ${vital.temperature}°C'),
                Text('Time: ${vital.timestamp}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
