// lib/widgets/patient_tabs/patient_records_tab.dart
import 'package:flutter/material.dart';
import '../../models/patient.dart';

class PatientRecordsTab extends StatelessWidget {
  final Patient patient;

  const PatientRecordsTab({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: patient.records.length,
      itemBuilder: (context, index) {
        final record = patient.records[index];
        return ExpansionTile(
          title: Text(record.diagnosis),
          subtitle: Text(record.date.toString()),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notes: ${record.notes}'),
                  const SizedBox(height: 8),
                  Text('Prescription:'),
                  ...record.prescription.map((med) => Text('- $med')),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
