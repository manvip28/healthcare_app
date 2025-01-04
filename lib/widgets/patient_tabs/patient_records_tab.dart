import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import '../../models/patient.dart';
import '../../models/medical_record.dart';
import '../../models/attachment.dart';

class PatientRecordsTab extends StatefulWidget {
  final Patient patient;

  const PatientRecordsTab({super.key, required this.patient});

  @override
  _PatientRecordsTabState createState() => _PatientRecordsTabState();
}

class _PatientRecordsTabState extends State<PatientRecordsTab> {
  late Future<Box<MedicalRecord>> _medicalRecordsBoxFuture;

  @override
  void initState() {
    super.initState();
    _medicalRecordsBoxFuture = Hive.openBox<MedicalRecord>('medical_records');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<MedicalRecord>>(
      future: _medicalRecordsBoxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print("Error loading records: ${snapshot.error}");
          return const Center(child: Text('Error loading records'));
        }

        final box = snapshot.data!;
        final patientRecords = box.values
            .where((record) => record.patientId == widget.patient.id)
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
                      if (record.prescription.isNotEmpty) ...[
                        const Text('Prescription:'),
                        ...record.prescription.map((med) => Text('- $med')).toList(),
                      ],
                      const SizedBox(height: 8),
                      if (record.attachments.isNotEmpty) ...[
                        const Text('Attachments:'),
                        ...record.attachments.map((attachment) {
                          return ListTile(
                            title: Text(attachment.fileName),
                            subtitle: Text(attachment.uploadDate.toString()),
                            leading: Icon(Icons.attach_file),
                            onTap: () => _openAttachmentFile(attachment.filePath, context),
                          );
                        }).toList(),
                      ],
                      const SizedBox(height: 16),
                      // Delete button with confirmation dialog
                      SizedBox(
                        width: double.infinity, // Same width as the appointment button
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Red color for the delete button
                            textStyle: const TextStyle(fontSize: 16),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _confirmDeleteRecord(record, context, box),
                          child: const Text('Delete Record'),
                        ),
                      ),
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

  // Function to open the attachment file
  Future<void> _openAttachmentFile(String filePath, BuildContext context) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      _showErrorDialog(result.message, context);
    }
  }

  // Function to show the confirmation dialog before deleting the record
  Future<void> _confirmDeleteRecord(MedicalRecord record, BuildContext context, Box<MedicalRecord> box) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this record?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ) ?? false;

    if (shouldDelete) {
      await _deleteRecord(record, context, box);
    }
  }

  // Function to delete the whole record
  Future<void> _deleteRecord(MedicalRecord record, BuildContext context, Box<MedicalRecord> box) async {
    await box.delete(record.key); // Delete the entire record

    // Refresh the state to remove the deleted record from the UI
    setState(() {
      // The FutureBuilder will automatically rebuild the widget and the record will be removed
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Record deleted')),
    );
  }

  // Function to show an error dialog
  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context, // Now using the passed context
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
