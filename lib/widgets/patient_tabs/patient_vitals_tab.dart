import 'package:flutter/material.dart';
import 'package:healthcare_app/models/patient.dart';
import 'package:healthcare_app/models/vitals.dart';
import 'package:healthcare_app/widgets/risk_assessment_widget.dart';
import 'package:healthcare_app/services/ml_risk_service.dart';
import 'package:healthcare_app/services/risk_assessment_service.dart' as riskService;
import 'package:healthcare_app/providers/patient_provider.dart';
import 'package:provider/provider.dart';
import 'generate_vitals_report.dart';
import 'generate_50_day_report.dart';

class PatientVitalsTab extends StatelessWidget {
  final Patient patient;
  const PatientVitalsTab({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);
    final vitalsForPatient = patientProvider.getVitalsForPatient(patient.id);

    return Scaffold(
      appBar: AppBar(title: Text('Patient Vitals')),
      body: SingleChildScrollView( // Wrap the body in SingleChildScrollView for scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => generateVitalsReport(context, patient), // Pass context here
                child: Text('Generate Vitals Report'),
              ),
              ElevatedButton(
                onPressed: () => generate50DayReport(patient),
                child: Text('Generate 50-Day Health Report'),
              ),
              const SizedBox(height: 20),
              // Wrap the ListView.builder in a Container with a fixed height to avoid layout overflow
              Container(
                height: MediaQuery.of(context).size.height * 0.5, // Adjust height to fit in the screen
                child: ListView.builder(
                  itemCount: vitalsForPatient.length,
                  itemBuilder: (context, index) {
                    final vitals = vitalsForPatient[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Vitals on ${vitals.timestamp.toLocal()}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Heart Rate: ${vitals.heartRate} BPM'),
                                Text('Blood Pressure: ${vitals.bloodPressure} mmHg'),
                                Text('Blood Sugar: ${vitals.bloodSugar} mg/dL'),
                                Text('Temperature: ${vitals.temperature} °C'),
                                Text('Symptoms Duration: ${vitals.duration}'),
                                // Display symptoms if any
                                Text(
                                  'Heart Attack Symptoms: ${vitals.heartAttackSymptoms.entries.where((e) => e.value).map((e) => e.key).join(', ')}',
                                ),
                                Text(
                                  'Hypoglycemic Symptoms: ${vitals.hypoglycemicSymptoms.entries.where((e) => e.value).map((e) => e.key).join(', ')}',
                                ),
                              ],
                            ),
                          ),
                          // Add Risk Assessment for the current vitals record
                          RiskAssessmentWidget(vitals: vitals),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
