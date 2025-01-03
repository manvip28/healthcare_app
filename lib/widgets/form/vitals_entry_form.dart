import 'package:flutter/material.dart';
import 'package:healthcare_app/models/vitals.dart';
import 'package:healthcare_app/providers/patient_provider.dart';
import 'package:provider/provider.dart';

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
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ...symptoms.keys.map((symptom) {
          // Bilingual symptom names
          String symptomLabel = symptom;
          String symptomLabelHindi = '';
          IconData icon;

          switch (symptom) {
            case 'Chest Pain':
              symptomLabelHindi = 'सीने में दर्द';
              icon = Icons.favorite; // Icon for Chest Pain
              break;
            case 'Shortness of Breath':
              symptomLabelHindi = 'सांस में तकलीफ';
              icon = Icons.air; // Icon for Shortness of Breath
              break;
            case 'Cold Sweat':
              symptomLabelHindi = 'ठंडी पसीना';
              icon = Icons.ac_unit; // Icon for Cold Sweat
              break;
            case 'Nausea':
              symptomLabelHindi = 'उल्टी आना';
              icon = Icons.warning; // Icon for Nausea
              break;
            case 'Jaw/Back Pain':
              symptomLabelHindi = 'जबड़े/पीठ में दर्द';
              icon = Icons.backspace; // Icon for Jaw/Back Pain
              break;
            case 'Confusion':
              symptomLabelHindi = 'उलझन';
              icon = Icons.help_outline; // Icon for Confusion
              break;
            case 'Weakness':
              symptomLabelHindi = 'कमज़ोरी';
              icon = Icons.accessibility_new; // Icon for Weakness
              break;
            case 'Dizziness':
              symptomLabelHindi = 'चक्कर आना';
              icon = Icons.rotate_left; // Icon for Dizziness
              break;
            case 'Trembling':
              symptomLabelHindi = 'काँपना';
              icon = Icons.vibration; // Icon for Trembling
              break;
            case 'Rapid Heartbeat':
              symptomLabelHindi = 'तेज़ दिल की धड़कन';
              icon = Icons.favorite_border; // Icon for Rapid Heartbeat
              break;
            default:
              icon = Icons.help; // Default icon
          }

          return CheckboxListTile(
            title: Row(
              children: [
                Icon(icon, size: 24), // Display icon next to symptom
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(symptomLabel), // English symptom
                    Text(
                      symptomLabelHindi,
                      style: TextStyle(fontSize: 18), // Increased font size for Hindi part
                    ),
                  ],
                ),
              ],
            ),
            value: symptoms[symptom],
            onChanged: (bool? value) {
              setState(() {
                symptoms[symptom] = value ?? false;
              });
            },
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  void _saveVitals() async {
    if (_formKey.currentState?.validate() ?? false) {
      final heartRate = int.tryParse(_heartRateController.text);
      final systolic = int.tryParse(_systolicController.text);
      final diastolic = int.tryParse(_diastolicController.text);
      final temperature = double.tryParse(_temperatureController.text);
      final bloodSugar = _bloodSugarController.text;

      if (heartRate == null || systolic == null || diastolic == null || temperature == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter valid values for all fields. / कृपया सभी क्षेत्रों के लिए सही मान दर्ज करें।')));
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

      try {
        // Get the PatientProvider instance
        final patientProvider = Provider.of<PatientProvider>(context, listen: false);

        // Get the patient
        final patient = patientProvider.getPatient(widget.patientId);

        // Add vitals for the patient
        await patientProvider.addVitalsForPatient(patient, vitals);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vitals saved successfully / लक्षण सफलतापूर्वक सहेजे गए')),
        );

        widget.onSave(vitals);
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving vitals: $e / लक्षण सहेजने में त्रुटि: $e')),
        );
      }
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
                decoration: InputDecoration(
                  labelText: 'Heart Rate (BPM) / हृदय गति (BPM)',
                  prefixIcon: Icon(Icons.favorite),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter heart rate / कृपया हृदय गति दर्ज करें';
                  final rate = int.tryParse(value);
                  if (rate == null || rate < 30 || rate > 250) {
                    return 'Enter a valid heart rate between 30 and 250 / 30 से 250 के बीच एक वैध हृदय गति दर्ज करें';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _systolicController,
                decoration: InputDecoration(
                  labelText: 'Systolic BP / सिस्टोलिक BP',
                  prefixIcon: Icon(Icons.monitor_heart),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter systolic blood pressure / कृपया सिस्टोलिक रक्त दबाव दर्ज करें';
                  final systolic = int.tryParse(value);
                  if (systolic == null || systolic < 50 || systolic > 250) {
                    return 'Enter a valid systolic BP / वैध सिस्टोलिक BP दर्ज करें';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _diastolicController,
                decoration: InputDecoration(
                  labelText: 'Diastolic BP / डायस्टोलिक BP',
                  prefixIcon: Icon(Icons.monitor_heart),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter diastolic blood pressure / कृपया डायस्टोलिक रक्त दबाव दर्ज करें';
                  final diastolic = int.tryParse(value);
                  if (diastolic == null || diastolic < 50 || diastolic > 150) {
                    return 'Enter a valid diastolic BP / वैध डायस्टोलिक BP दर्ज करें';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _temperatureController,
                decoration: InputDecoration(
                  labelText: 'Temperature (°C) / शरीर का तापमान (°C)',
                  prefixIcon: Icon(Icons.thermostat),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter body temperature / कृपया शरीर का तापमान दर्ज करें';
                  final temp = double.tryParse(value);
                  if (temp == null || temp < 30 || temp > 45) {
                    return 'Enter a valid temperature between 30 and 45°C / 30 से 45°C के बीच एक वैध तापमान दर्ज करें';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bloodSugarController,
                decoration: InputDecoration(
                  labelText: 'Blood Sugar (mg/dL) / ब्लड शुगर (mg/dL)',
                  prefixIcon: Icon(Icons.bloodtype),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter blood sugar / कृपया रक्त शुगर दर्ज करें';
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration of Symptoms / लक्षणों की अवधि',
                  prefixIcon: Icon(Icons.access_time), // Clock icon
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter symptom duration / कृपया लक्षणों की अवधि दर्ज करें';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildSymptomsSection('Heart Attack Symptoms / हृदय गति के लक्षण', heartAttackSymptoms),
              _buildSymptomsSection('Hypoglycemic Symptoms / हाइपोग्लाइसीमिया के लक्षण', hypoglycemicSymptoms),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveVitals,
                child: Text('Save Vitals / लक्षण सेव करें'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
