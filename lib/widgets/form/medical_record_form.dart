import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import '../../models/medical_record.dart';
import '../../models/attachment.dart';

class MedicalRecordForm extends StatefulWidget {
  final Function(MedicalRecord) onSave;
  final String patientId;

  const MedicalRecordForm({super.key, required this.onSave, required this.patientId});

  @override
  State<MedicalRecordForm> createState() => _MedicalRecordFormState();
}

class _MedicalRecordFormState extends State<MedicalRecordForm> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  final List<Attachment> _attachments = [];

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
      debugPrint('Files picked: ${_attachments.length}');
    }
  }

  void _saveMedicalRecord() async {
    debugPrint('Attempting to save medical record...');
    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint('Form is valid, saving record...');
      debugPrint('Diagnosis: ${_diagnosisController.text}');
      debugPrint('Notes: ${_notesController.text}');
      debugPrint('Attachments count: ${_attachments.length}');

      final record = MedicalRecord(
        patientId: widget.patientId,
        diagnosis: _diagnosisController.text,
        prescription: [], // No prescription data
        notes: _notesController.text,
        date: DateTime.now(),
        attachments: _attachments,
      );

      try {
        var box = await Hive.openBox<MedicalRecord>('medical_records');
        debugPrint('Opened medical_records box');

        await box.add(record);
        debugPrint('Medical record saved: ${record.diagnosis}');

        widget.onSave(record);
        Navigator.pop(context);
      } catch (e) {
        debugPrint('Error saving record: $e');
        _showErrorDialog("Error saving record: $e");
      }
    } else {
      debugPrint('Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields / कृपया सभी आवश्यक फ़ील्ड भरें'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: const Text('Add Record / रिकॉर्ड जोड़ें'),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form( // Added Form widget here
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _diagnosisController,
                    decoration: const InputDecoration(
                      labelText: 'Diagnosis / निदान *',
                      hintText: 'Enter diagnosis / निदान दर्ज करें',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Diagnosis is required / निदान आवश्यक है';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes / टिप्पणियाँ',
                      hintText: 'Enter additional notes / अतिरिक्त टिप्पणियाँ दर्ज करें',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Add Attachments / अटैचमेंट्स जोड़ें'),
                  ),
                  if (_attachments.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Attachments / अटैचमेंट्स',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _attachments.length,
                      itemBuilder: (context, index) {
                        final attachment = _attachments[index];
                        return ListTile(
                          leading: Icon(_getFileIcon(attachment.fileType)),
                          title: Text(attachment.fileName),
                          onTap: () => _openFile(attachment.filePath),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => setState(() {
                              _attachments.removeAt(index);
                            }),
                          ),
                        );
                      },
                    ),
                    if (_attachments.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _attachments.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Delete All Attachments / सभी अटैचमेंट्स हटाएं'),
                        ),
                      ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveMedicalRecord,
                      child: const Text('Save Record / रिकॉर्ड सेव करें'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

  Future<void> _openFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      _showErrorDialog("Error opening file: ${result.message}");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
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

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}