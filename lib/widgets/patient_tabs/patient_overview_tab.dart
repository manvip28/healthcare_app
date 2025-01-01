// lib/widgets/patient_tabs/patient_overview_tab.dart
import 'package:flutter/material.dart';
import '../../models/patient.dart';

class PatientOverviewTab extends StatelessWidget {
  final Patient patient;

  const PatientOverviewTab({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Patient ID: ${patient.id}'),
          Text('Name: ${patient.name}'),
          Text('Age: ${patient.age}'),
          const SizedBox(height: 16),
          const Text('Recent Activity:'),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: patient.records.take(5).length,
      itemBuilder: (context, index) {
        final record = patient.records[index];
        return ListTile(
          title: Text(record.diagnosis),
          subtitle: Text(record.date.toString()),
        );
      },
    );
  }
}
