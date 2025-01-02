import 'package:flutter/material.dart';
import 'package:healthcare_app/models/vitals.dart';

class VitalsEntryForm extends StatefulWidget {
  final Function(Vitals) onSave;
  final String patientId;

  const VitalsEntryForm({
    super.key,
    required this.onSave,
    required this.patientId,
  });

  @override
  State<VitalsEntryForm> createState() => _VitalsEntryFormState();
}

class _VitalsEntryFormState extends State<VitalsEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _heartRateController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _durationController = TextEditingController();

  // Symptoms maps
  final Map<String, bool> heartAttackSymptoms = {
    'Chest Pain': false,
    'Shortness of Breath': false,
    'Cold Sweat': false,
    'Nausea': false,
    'Jaw/Back Pain': false,
  };

  final Map<String, bool> hypoglycemicSymptoms = {
    'Confusion': false,
    'Weakness': false,
    'Dizziness': false,
    'Trembling': false,
    'Rapid Heartbeat': false,
  };

  @override
  void dispose() {
    _heartRateController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _temperatureController.dispose();
    _bloodSugarController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Widget _buildSymptomsSection(String title, Map<String, bool> symptoms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...symptoms.keys.map((symptom) => CheckboxListTile(
          title: Text(symptom),
          value: symptoms[symptom],
          onChanged: (bool? value) {
            setState(() {
              symptoms[symptom] = value ?? false;
            });
          },
        )),
        const SizedBox(height: 16),
      ],
    );
  }

  void _saveVitals() {
    if (_formKey.currentState?.validate() ?? false) {
      final heartRate = int.tryParse(_heartRateController.text);
      final systolic = int.tryParse(_systolicController.text);
      final diastolic = int.tryParse(_diastolicController.text);
      final temperature = double.tryParse(_temperatureController.text);
      final bloodSugar = _bloodSugarController.text;

      if (heartRate == null || systolic == null || diastolic == null || temperature == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid values for all fields')),
        );
        return;
      }

      final vitals = Vitals(
        patientId: widget.patientId,
        heartRate: heartRate,
        bloodPressure: '$systolic/$diastolic',
        bloodSugar: bloodSugar,
        temperature: temperature,
        timestamp: DateTime.now(),
        heartAttackSymptoms: Map<String, bool>.from(heartAttackSymptoms),
        hypoglycemicSymptoms: Map<String, bool>.from(hypoglycemicSymptoms),
        duration: _durationController.text,
      );

      widget.onSave(vitals);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _heartRateController,
                decoration: const InputDecoration(labelText: 'Heart Rate (BPM)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter heart rate';
                  final rate = int.tryParse(value);
                  if (rate == null || rate < 30 || rate > 250) {
                    return 'Enter a valid heart rate between 30 and 250';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _systolicController,
                decoration: const InputDecoration(labelText: 'Systolic BP'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter systolic blood pressure';
                  final systolic = int.tryParse(value);
                  if (systolic == null || systolic < 50 || systolic > 250) {
                    return 'Enter a valid systolic BP';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _diastolicController,
                decoration: const InputDecoration(labelText: 'Diastolic BP'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter diastolic blood pressure';
                  final diastolic = int.tryParse(value);
                  if (diastolic == null || diastolic < 50 || diastolic > 150) {
                    return 'Enter a valid diastolic BP';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _temperatureController,
                decoration: const InputDecoration(labelText: 'Temperature (°C)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter body temperature';
                  final temp = double.tryParse(value);
                  if (temp == null || temp < 30 || temp > 45) {
                    return 'Enter a valid temperature between 30 and 45°C';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bloodSugarController,
                decoration: const InputDecoration(labelText: 'Blood Sugar (mg/dL)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter blood sugar';
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration of Symptoms'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter symptom duration';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildSymptomsSection('Heart Attack Symptoms', heartAttackSymptoms),
              _buildSymptomsSection('Hypoglycemic Symptoms', hypoglycemicSymptoms),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveVitals,
                child: const Text('Save Vitals'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
