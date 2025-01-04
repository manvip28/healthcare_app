import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:healthcare_app/models/patient.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import '../../services/ml_risk_service.dart';

Future<void> generate50DayReport(Patient patient) async {
  try {
    // Generate 50 days of sample data and sort by timestamp
    final samples = List.generate(50, (index) => _generateSingleSample())
      ..sort((a, b) => DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp'])));

    // Prepare LSTM input for diabetes prediction
    final lstmInput = _prepareLSTMSequences(samples);

    // Load the model
    await MLRiskService.loadModels();

    // Get predictions from the diabetes model for the batch of 50 records
    final predictions = await MLRiskService.predictDiabetesRisk(lstmInput);

    // Ensure predictions are not empty
    if (predictions.isEmpty) {
      print("No predictions received.");
      return;
    }

    // Close the model after predictions
    MLRiskService.closeModels();

    // Create PDF document
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) => [
        pw.Header(level: 0, child: pw.Text('50-Day Health Analysis Report', style: pw.TextStyle(fontSize: 24))),
        pw.Header(level: 1, child: pw.Text('Executive Summary')),
        pw.Paragraph(text: 'Diabetes Status: ${predictions['diabetes']}'),
        pw.Paragraph(text: 'Diabetes Trend: ${predictions['diabetesTrend']}'),
        pw.Header(level: 1, child: pw.Text('Detailed Measurements')),
        ...samples.map((sample) => _buildSampleRecord(sample)),
        pw.Header(level: 1, child: pw.Text('Statistical Analysis')),
        _buildStatisticalSummary(samples),
      ],
    ));

    // Save the PDF file in the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/50_day_diabetes_analysis.pdf');
    await file.writeAsBytes(await pdf.save());

    // Optionally print the PDF if needed
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  } catch (e) {
    print("Error generating report: $e");
  }
}

pw.Widget _buildSampleRecord(Map<String, dynamic> sample) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text('Timestamp: ${sample['timestamp']}'),
      pw.Text('Heart Rate: ${sample['heartRate']} BPM'),
      pw.Text('Blood Sugar: ${sample['bloodSugar']} mg/dL'),
      pw.Text('Blood Pressure: ${sample['bloodPressureSystolic']}/${sample['bloodPressureDiastolic']} mmHg'),
      pw.Text('Temperature: ${sample['temperature']} °C'),
    ],
  );
}

pw.Widget _buildStatisticalSummary(List<Map<String, dynamic>> samples) {
  final heartRates = samples.map((s) => s['heartRate']).toList();
  final bloodSugars = samples.map((s) => s['bloodSugar']).toList();

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Heart Rate Statistics:'),
      pw.Bullet(text: 'Average: ${_calculateAverage(heartRates.map((e) => e as num).toList()).toStringAsFixed(1)} BPM'),
      pw.Bullet(text: 'Range: ${heartRates.reduce((a, b) => a > b ? a : b)} - ${heartRates.reduce((a, b) => a < b ? a : b)} BPM'),
      pw.SizedBox(height: 10),
      pw.Text('Blood Sugar Statistics:'),
      pw.Bullet(text: 'Average: ${_calculateAverage(bloodSugars.map((e) => e as num).toList()).toStringAsFixed(1)} mg/dL'),
      pw.Bullet(text: 'Range: ${bloodSugars.reduce((a, b) => a > b ? a : b)} - ${bloodSugars.reduce((a, b) => a < b ? a : b)} mg/dL'),
    ],
  );
}

double _calculateAverage(List<num> values) {
  return values.reduce((a, b) => a + b) / values.length;
}

Map<String, dynamic> _generateSingleSample() {
  final random = Random();
  final chestPain = random.nextDouble() < 0.15 ? 1 : 0;
  final shortnessBreath = random.nextDouble() < 0.1 ? 1 : 0;

  return {
    'heartRate': random.nextInt(60) + 60,
    'bloodPressureSystolic': random.nextInt(30) + 110,
    'bloodPressureDiastolic': random.nextInt(20) + 70,
    'temperature': double.parse((random.nextDouble() * 2 + 36.5).toStringAsFixed(1)),
    'bloodSugar': random.nextInt(110) + 70,
    'heartAttackSymptoms': {
      'chestPain': chestPain,
      'shortnessBreath': shortnessBreath
    },
    'timestamp': DateTime.now().subtract(Duration(days: random.nextInt(50))).toString(),
    'generalHealth': random.nextInt(3),  // 0=Good, 1=Average, 2=Bad
    'diabetesTrend': random.nextInt(3)  // 0=Good, 1=Average, 2=Worse
  };
}

List<List<List<double>>> _prepareLSTMSequences(List<Map<String, dynamic>> samples) {
  int windowSize = 5;  // Adjust window size to match model's sequence length
  List<List<List<double>>> sequences = [];

  for (int i = windowSize; i < samples.length; i++) {
    List<List<double>> sequence = [];
    for (int j = i - windowSize; j < i; j++) {
      sequence.add([
        samples[j]['heartRate'].toDouble(),
        samples[j]['bloodPressureSystolic'].toDouble(),
        samples[j]['bloodPressureDiastolic'].toDouble(),
        samples[j]['temperature'].toDouble(),
        samples[j]['bloodSugar'].toDouble()
      ]);
    }
    sequences.add(sequence);
  }

  return sequences;
}
