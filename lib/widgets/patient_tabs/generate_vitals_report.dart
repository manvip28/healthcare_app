import 'package:flutter/cupertino.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:healthcare_app/models/vitals.dart';
import 'package:path_provider/path_provider.dart'; // For saving files locally
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/patient.dart';
import '../../providers/patient_provider.dart';

Future<void> generateVitalsReport(BuildContext context, Patient patient) async {
  final patientProvider = Provider.of<PatientProvider>(context, listen: false);

  // Ensure vitals are loaded from Hive before fetching
  await patientProvider.loadVitals();

  // Fetch vitals after ensuring they are loaded
  final vitals = await _fetchVitals(context, patient);

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Patient ID: ${patient.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            // Patient Details Section
            pw.Text('Name: ${patient.name}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Age: ${patient.age} years'),
            pw.Text('Diagnosis: ${patient.diagnosis}'),
            pw.SizedBox(height: 20),
            pw.Text('Last Vitals Record:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            _buildVitalsSummaryForPdf(vitals),
            pw.SizedBox(height: 20),
            pw.Text('Vitals Records:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...vitals.map((vital) => _buildVitalRecordForPdf(vital)),
          ],
        );
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/patient_vitals_report.pdf');
  await file.writeAsBytes(await pdf.save());
  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

pw.Widget _buildVitalsSummaryForPdf(List<Vitals> vitals) {
  final lastVital = vitals.last;
  final bloodPressureParts = lastVital.bloodPressure.split('/');
  final systolic = bloodPressureParts.isNotEmpty ? bloodPressureParts[0] : 'N/A';
  final diastolic = bloodPressureParts.length > 1 ? bloodPressureParts[1] : 'N/A';

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Heart Rate: ${lastVital.heartRate} BPM'),
      pw.Text('Blood Pressure: $systolic/$diastolic mmHg'),
      pw.Text('Temperature: ${lastVital.temperature}°C'),
      pw.Text('Blood Sugar: ${lastVital.bloodSugar} mg/dL'),
    ],
  );
}

pw.Widget _buildVitalRecordForPdf(Vitals vital) {
  final bloodPressureParts = vital.bloodPressure.split('/');
  final systolic = bloodPressureParts.isNotEmpty ? bloodPressureParts[0] : 'N/A';
  final diastolic = bloodPressureParts.length > 1 ? bloodPressureParts[1] : 'N/A';

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Date: ${vital.timestamp.toIso8601String().split('T')[0]}'),
      pw.Text('Heart Rate: ${vital.heartRate} BPM'),
      pw.Text('Blood Pressure: $systolic/$diastolic mmHg'),
      pw.Text('Temperature: ${vital.temperature}°C'),
      pw.Text('Blood Sugar: ${vital.bloodSugar} mg/dL'),
      pw.SizedBox(height: 10),
    ],
  );
}

Future<List<Vitals>> _fetchVitals(BuildContext context, Patient patient) async {
  final patientProvider = Provider.of<PatientProvider>(context, listen: false);
  return patientProvider.getVitalsForPatient(patient.id);
}
