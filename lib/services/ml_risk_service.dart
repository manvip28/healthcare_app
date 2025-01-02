import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:hive/hive.dart';
import 'package:healthcare_app/models/vitals.dart';

class MLRiskService {
  static Interpreter? _interpreter;

  // Initialize the model
  static Future<void> initializeModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/health_model.tflite');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  // Predict risk based on multiple vitals records
  static Future<String> predictRiskFromAllRecords(String patientId) async {
    if (_interpreter == null) {
      await initializeModel();
    }

    try {
      // Access the vitals data from Hive for the given patient
      final vitalsBox = await Hive.openBox<Vitals>('vitals');
      List<Vitals> patientVitalsList = vitalsBox.values
          .where((vital) => vital.patientId == patientId)
          .toList();

      if (patientVitalsList.isEmpty) {
        return "No vitals found for the patient";
      }

      // Extract vitals from all records
      List<List<double>> vitals = patientVitalsList.map((vital) {
        return [
          vital.heartRate.toDouble(),
          double.parse(vital.bloodPressure.split('/')[0]), // Systolic BP
          double.parse(vital.bloodSugar),
          vital.temperature,
        ];
      }).toList();

      // Prepare input data: list of records
      var input = [vitals];

      // Prepare output tensor for 3 classes (normal, slightly abnormal, highly abnormal)
      var output = List.filled(1, List.filled(3, 0.0));

      // Run inference
      _interpreter?.run(input, output);

      // Aggregate the output and return the class with the majority count
      var maxIndex = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
      switch (maxIndex) {
        case 0:
          return "Normal";
        case 1:
          return "Slightly Abnormal";
        case 2:
          return "Highly Abnormal";
        default:
          return "Unknown";
      }
    } catch (e) {
      print('Error during prediction: $e');
      return "Prediction failed";
    }
  }
}
