import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_app/models/patient.dart';
import '../providers/patient_provider.dart';

class AddPatientPage extends StatefulWidget {
  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _familyHistoryController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _treatmentsController = TextEditingController();
  final TextEditingController _genderController = TextEditingController(); // Added controller for gender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Patient / नया मरीज जोड़ें")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Patient Name / मरीज का नाम',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name / कृपया नाम दर्ज करें';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age / आयु',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age / कृपया आयु दर्ज करें';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number for age / कृपया आयु के लिए एक मान्य संख्या दर्ज करें';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _diagnosisController,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis / निदान',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a diagnosis / कृपया निदान दर्ज करें';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Gender text field
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(
                  labelText: 'Gender / लिंग',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter gender / कृपया लिंग दर्ज करें';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Optional Fields
              TextFormField(
                controller: _medicalHistoryController,
                decoration: const InputDecoration(
                  labelText: 'Medical History / चिकित्सा इतिहास',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _allergiesController,
                decoration: const InputDecoration(
                  labelText: 'Allergies / एलर्जी',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _familyHistoryController,
                decoration: const InputDecoration(
                  labelText: 'Family Medical History / पारिवारिक चिकित्सा इतिहास',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _medicationsController,
                decoration: const InputDecoration(
                  labelText: 'Medications / दवाइयाँ',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _treatmentsController,
                decoration: const InputDecoration(
                  labelText: 'Ongoing Treatments / जारी उपचार',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final age = int.parse(_ageController.text);

                    final patient = Patient(
                      id: DateTime.now().toString(),
                      name: _nameController.text,
                      age: age,
                      gender: _genderController.text, // Use text from gender field
                      vitals: [],
                      records: [],
                      diagnosis: _diagnosisController.text,
                      medicalHistory: _medicalHistoryController.text.isEmpty ? null : _medicalHistoryController.text,
                      allergies: _allergiesController.text.isEmpty ? null : _allergiesController.text,
                      familyMedicalHistory: _familyHistoryController.text.isEmpty ? null : _familyHistoryController.text,
                      medications: _medicationsController.text.isEmpty ? null : _medicationsController.text,
                      ongoingTreatments: _treatmentsController.text.isEmpty ? null : _treatmentsController.text,
                    );
                    Provider.of<PatientProvider>(context, listen: false)
                        .addPatient(patient);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Patient / मरीज जोड़ें'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
