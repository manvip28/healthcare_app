import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_app/models/patient.dart';
import '../providers/patient_provider.dart';

class AddPatientPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();  // Controller for age
  final TextEditingController _diagnosisController = TextEditingController(); // New controller for diagnosis

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Patient")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ageController, // Age input field
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number for age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _diagnosisController, // Diagnosis input field
                decoration: const InputDecoration(labelText: 'Diagnosis'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a diagnosis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final age = int.parse(_ageController.text);
                    final dateOfBirth = DateTime.now().subtract(Duration(days: 365 * age)); // Calculate date of birth

                    final patient = Patient(
                      id: DateTime.now().toString(), // Use a unique ID
                      name: _nameController.text,
                      dateOfBirth: dateOfBirth, // Pass the calculated date of birth
                      vitals: [], // Empty vitals for now
                      records: [], // Empty records for now
                      diagnosis: _diagnosisController.text, // Pass the diagnosis
                    );
                    Provider.of<PatientProvider>(context, listen: false)
                        .addPatient(patient);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
