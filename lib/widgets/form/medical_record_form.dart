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
    }
  }

  void _saveMedicalRecord() async {
    if (_formKey.currentState?.validate() ?? false) {
      final record = MedicalRecord(
        patientId: widget.patientId,
        diagnosis: _diagnosisController.text,
        prescription: [], // No prescription data
        notes: _notesController.text,
        date: DateTime.now(),
        attachments: _attachments,
      );

      var box = await Hive.openBox<MedicalRecord>('medical_records');
      await box.add(record);

      widget.onSave(record);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 22.0), // Add space above the title
          child: const Text('Add Record / रिकॉर्ड जोड़ें'),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 18.0), // Add space to move the icon down
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false, // Prevents resizing when the keyboard appears
      body: SafeArea(
        child: SingleChildScrollView( // Ensures scrolling when content overflows
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // Adjusted padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _diagnosisController,
                  decoration: const InputDecoration(labelText: 'Diagnosis / निदान'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16), // Added space between fields
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes / टिप्पणियाँ'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16), // Added space between fields
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Add Attachments / अटैचमेंट्स जोड़ें'),
                ),
                const SizedBox(height: 16), // Added space between the button and list
                if (_attachments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Avoid nested scroll issues
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
                      child: const Text('Delete All Attachments'),
                    ),
                  ),
                ],
                const SizedBox(height: 24), // Added extra space before save button
                ElevatedButton(
                  onPressed: _saveMedicalRecord,
                  child: const Text('Save Record / रिकॉर्ड सेव करें'),
                ),
              ],
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
}
