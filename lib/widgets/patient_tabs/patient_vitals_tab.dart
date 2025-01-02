import 'package:flutter/material.dart';
import 'package:healthcare_app/models/patient.dart';
import 'package:healthcare_app/models/vitals.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:healthcare_app/widgets/risk_assessment_widget.dart';
import 'package:path_provider/path_provider.dart'; // For saving files locally
import 'dart:io';
import '../../providers/patient_provider.dart';
import '../../services/risk_assessment_service.dart' as riskService;
import '../../services/ml_risk_service.dart' as mlRiskService;
import 'package:pdf/pdf.dart';

class PatientVitalsTab extends StatelessWidget {
  final Patient patient;

  const PatientVitalsTab({super.key, required this.patient});

  String _getRiskStatus(bool isHighRisk) {
    return isHighRisk ? 'High Risk' : 'Low Risk';
  }

  Future<String> _getRiskStatusFromMLModel(String patientId) async {
    return await mlRiskService.MLRiskService.predictRiskFromAllRecords(patientId);
  }

  Widget _buildSymptomsList(Map<String, bool> symptoms, String title) {
    final activeSymptoms = symptoms.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (activeSymptoms.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...activeSymptoms.map((symptom) => Text('• $symptom')),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _generatePdf(List<Vitals> vitals) async {
    final riskStatus = await _getRiskStatusFromMLModel(patient.id); // Get the risk status before building the PDF

    final pdf = pw.Document();

    // Add title for the PDF page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Patient ID: ${patient.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Vitals Summary:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              _buildVitalsSummaryForPdf(vitals),
              pw.SizedBox(height: 20),
              pw.Text('Vitals Records:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              ...vitals.map((vital) => _buildVitalRecordForPdf(vital)),
              pw.SizedBox(height: 20),
              pw.Text('Risk Status for All Records: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(riskStatus), // Use the pre-fetched risk status here
            ],
          );
        },
      ),
    );

    // Save the document locally
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/patient_vitals_report.pdf');
    await file.writeAsBytes(await pdf.save());

    // Optionally, you can also print it if needed
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.Widget _buildVitalsSummaryForPdf(List<Vitals> vitals) {
    // Summarize the overall vitals (averages or other statistics)
    double averageHeartRate = 0;
    double averageBloodSugar = 0;
    double averageTemperature = 0;

    for (var vital in vitals) {
      averageHeartRate += vital.heartRate.toDouble();
      averageBloodSugar += double.tryParse(vital.bloodSugar) ?? 0;
      averageTemperature += vital.temperature;
    }

    int vitalsCount = vitals.length;

    // Calculate averages
    averageHeartRate /= vitalsCount;
    averageBloodSugar /= vitalsCount;
    averageTemperature /= vitalsCount;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Average Heart Rate: ${averageHeartRate.toStringAsFixed(1)} BPM'),
        pw.Text('Average Blood Sugar: ${averageBloodSugar.toStringAsFixed(1)} mg/dL'),
        pw.Text('Average Temperature: ${averageTemperature.toStringAsFixed(1)} °C'),
      ],
    );
  }

  pw.Widget _buildVitalRecordForPdf(Vitals vital) {
    // Perform risk assessment
    final assessment = riskService.RiskAssessment.assessRisk(vital);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Recorded on: ${vital.timestamp.toString().split('.')[0]}'),
        pw.Text('Heart Rate: ${vital.heartRate} BPM'),
        pw.Text('Blood Pressure: ${vital.bloodPressure}'),
        pw.Text('Blood Sugar: ${vital.bloodSugar} mg/dL'),
        pw.Text('Temperature: ${vital.temperature} °C'),
        pw.Text('Duration: ${vital.duration}'),
        pw.SizedBox(height: 10),

        // Risk assessment results
        pw.Text('Heart Attack Risk: ${assessment.heartAttackRiskScore.toStringAsFixed(1)}%',
            style: _getRiskStyle(assessment.heartAttackRiskScore)),
        pw.Text('Hypoglycemic Shock Risk: ${assessment.hypoglycemicRiskScore.toStringAsFixed(1)}%',
            style: _getRiskStyle(assessment.hypoglycemicRiskScore)),

        pw.SizedBox(height: 8),

        // Displaying the Risk Status
        pw.Text(
          'Risk Status: ${_getRiskStatus(assessment.isHighRisk)}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: _getRiskColor(assessment.isHighRisk)),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.TextStyle _getRiskStyle(double score) {
    return pw.TextStyle(
      color: score > 70 ? PdfColors.red : score > 30 ? PdfColors.orange : PdfColors.green,
    );
  }

  PdfColor _getRiskColor(bool isHighRisk) {
    return isHighRisk ? PdfColors.red : PdfColors.green;
  }

  @override
  Widget build(BuildContext context) {
    final vitals = patient.vitals;

    return Scaffold(
      appBar: AppBar(title: const Text('Patient Vitals')),
      body: ListView(
        children: [
          ...vitals.map((vital) => _buildVitalRecord(vital)),
          ElevatedButton(
            onPressed: () async {
              await _generatePdf(vitals); // Ensure this is an async function
            },
            child: const Text('Generate PDF Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalRecord(Vitals vital) {
    // Displaying each vital record along with the associated risk assessment
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Recorded on: ${vital.timestamp.toString().split('.')[0]}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Heart Rate: ${vital.heartRate} BPM'),
            Text('Blood Pressure: ${vital.bloodPressure}'),
            Text('Blood Sugar: ${vital.bloodSugar} mg/dL'),
            Text('Temperature: ${vital.temperature} °C'),
            Text('Duration: ${vital.duration}'),
            const SizedBox(height: 10),

            // Integrating Risk Assessment Widget
            RiskAssessmentWidget(vitals: vital),
          ],
        ),
      ),
    );
  }
}
