import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../models/patient.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _addPatient() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final age = int.tryParse(_ageController.text);

      if (age != null) {
        final patient = Patient(
          id: DateTime.now().toString(),  // You can generate an ID based on timestamp or another method
          name: name,
          age: age,
        );

        // Add the patient using the PatientProvider
        Provider.of<PatientProvider>(context, listen: false).addPatient(patient);

        // Go back to the previous screen after adding the patient
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Patient Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPatient,
                child: const Text('Add Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
