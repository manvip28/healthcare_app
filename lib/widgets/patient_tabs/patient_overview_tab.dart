import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/patient.dart';

class PatientOverviewTab extends StatelessWidget {
  final Patient patient;
  final dateFormat = DateFormat('MMM d, yyyy');

  PatientOverviewTab({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildLatestVitals(),
            const SizedBox(height: 24),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  // Builds the information card for the patient
  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Patient ID', patient.id),
            _buildInfoRow('Name', patient.name),
            _buildInfoRow('Age', '${patient.age} years'),
          ],
        ),
      ),
    );
  }

  // Builds a single row of information with a label and value
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Displays the latest vitals of the patient
  Widget _buildLatestVitals() {
    if (patient.vitals.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No vitals recorded'),
        ),
      );
    }

    final latest = patient.vitals.last;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Vitals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text('Heart Rate: ${latest.heartRate} BPM'),
            Text('Blood Pressure: ${latest.bloodPressure}'),
            Text('Temperature: ${latest.temperature}°C'),
            Text('Recorded: ${dateFormat.format(latest.timestamp)}'),
          ],
        ),
      ),
    );
  }

  // Displays the recent activity (medical records) of the patient
  Widget _buildRecentActivity() {
    if (patient.records.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No recent activity'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: patient.records.take(5).length,
              itemBuilder: (context, index) {
                final record = patient.records[index];
                return ListTile(
                  title: Text(record.diagnosis),
                  subtitle: Text(dateFormat.format(record.date)),
                  leading: const Icon(Icons.medical_services),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
