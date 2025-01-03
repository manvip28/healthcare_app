import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/patient.dart';
import '../../models/medical_record.dart';

class PatientRecordsTab extends StatelessWidget {
  final Patient patient;

  const PatientRecordsTab({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<MedicalRecord>>(
      future: Hive.openBox<MedicalRecord>('medical_records'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print("Error loading records: ${snapshot.error}");
          return const Center(child: Text('Error loading records'));
        }

        final box = snapshot.data!;
        // Filter medical records by patient ID or diagnosis
        final patientRecords = box.values
            .where((record) => record.patientId == patient.id) // Replace with the correct key
            .toList();

        return ListView.builder(
          itemCount: patientRecords.length,
          itemBuilder: (context, index) {
            final record = patientRecords[index];
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
                      const SizedBox(height: 8),
                      if (record.attachments.isNotEmpty) ...[
                        const Text('Attachments:'),
                        ...record.attachments.map((attachment) => ListTile(
                          title: Text(attachment.fileName),
                          subtitle: Text(attachment.uploadDate.toString()),
                          leading: Icon(Icons.attach_file),
                        )),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
