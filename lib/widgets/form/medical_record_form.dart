import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/medical_record.dart';
import '../../models/attachment.dart';  // Import the new attachment model file

class MedicalRecordForm extends StatefulWidget {
  final Function(MedicalRecord) onSave;
  final String patientId; // Added patientId as a parameter

  const MedicalRecordForm({super.key, required this.onSave, required this.patientId});

  @override
  State<MedicalRecordForm> createState() => _MedicalRecordFormState();
}

class _MedicalRecordFormState extends State<MedicalRecordForm> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  final List<String> _prescriptions = [];
  final List<Attachment> _attachments = [];
  final _prescriptionController = TextEditingController();

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _attachments.addAll(
          result.files.map((file) => Attachment(
            fileName: file.name,
            filePath: file.path!,
            uploadDate: DateTime.now(),
            fileType: file.extension ?? '',
          )),
        );
      });
    }
  }

  void _addPrescription() {
    if (_prescriptionController.text.isNotEmpty) {
      setState(() {
        _prescriptions.add(_prescriptionController.text);
        _prescriptionController.clear();
      });
    }
  }

  void _saveMedicalRecord() async {
    if (_formKey.currentState?.validate() ?? false) {
      final record = MedicalRecord(
        patientId: widget.patientId, // Include the patientId here
        diagnosis: _diagnosisController.text,
        prescription: _prescriptions,
        notes: _notesController.text,
        date: DateTime.now(),
        attachments: _attachments,
      );

      var box = await Hive.openBox<MedicalRecord>('medical_records');
      await box.add(record);  // Save record to Hive

      widget.onSave(record);  // Optionally trigger the parent onSave function
      Navigator.pop(context);  // Close the form
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _diagnosisController,
            decoration: const InputDecoration(labelText: 'Diagnosis'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _prescriptionController,
                  decoration: const InputDecoration(labelText: 'Add Prescription'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addPrescription,
              ),
            ],
          ),
          if (_prescriptions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _prescriptions.map((prescription) => Chip(
                label: Text(prescription),
                onDeleted: () => setState(() => _prescriptions.remove(prescription)),
              )).toList(),
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.attach_file),
            label: const Text('Add Attachments'),
          ),
          if (_attachments.isNotEmpty) ...[
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _attachments.length,
              itemBuilder: (context, index) {
                final attachment = _attachments[index];
                return ListTile(
                  leading: Icon(_getFileIcon(attachment.fileType)),
                  title: Text(attachment.fileName),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() => _attachments.removeAt(index)),
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveMedicalRecord,
            child: const Text('Save Record'),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }
}
