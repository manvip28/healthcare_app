import 'package:tflite_flutter/tflite_flutter.dart'; // Correct TensorFlow Lite import
import 'dart:math';

class MLRiskService {
  static late Interpreter _diabetesInterpreter;

  // Load the model without Flex delegate support
  static Future<void> loadModels() async {
    try {
      final interpreterOptions = InterpreterOptions();

      // Load the model from the correct asset path
      _diabetesInterpreter = await Interpreter.fromAsset(
        'assets/models/diabetes_trend_model.tflite',  // Make sure the path is correct
        options: interpreterOptions,
      );

      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading diabetes model: $e");
    }
  }

  // Predict the diabetes risk from multiple records at once
  static Future<Map<String, String>> predictDiabetesRisk(List<List<List<double>>> input) async {
    try {
      // Check if the interpreter is initialized
      if (_diabetesInterpreter == null) {
        print("Error: The model is not loaded.");
        return {};
      }

      // Initialize the output buffer for predictions
      List<List<double>> diabetesOutputs = List.generate(input.length, (i) => List.filled(3, 0));

      // Reshape the input to match the model's expected input (batch size, sequence length, number of features)
      var reshapedInput = input;

      // Run diabetes prediction model for the entire batch
      _diabetesInterpreter.run(reshapedInput, diabetesOutputs);

      // Convert raw outputs to final predictions
      var diabetesPredictions = diabetesOutputs.map((o) => o.indexOf(o.reduce(max))).toList();

      // Ensure predictions are not empty
      if (diabetesPredictions.isEmpty) {
        print("Error: No diabetes predictions generated.");
        return {};
      }

      return {
        'diabetes': _getDiabetesResult(diabetesPredictions),
        'diabetesTrend': _analyzeDiabetesTrend(diabetesPredictions),
      };
    } catch (e) {
      print("Error predicting diabetes risk: $e");
      return {};
    }
  }

  // Helper function to determine the diabetes result from predictions
  static String _getDiabetesResult(List<int> predictions) {
    final counts = [0, 0, 0];
    for (var p in predictions) counts[p]++;
    final maxIndex = counts.indexOf(counts.reduce(max));
    return ['Good', 'Average (Need to make changes in the lifestyle)', 'Worse (Make changes in the medications)'][maxIndex];
  }

  // Analyze the diabetes trend over time
  static String _analyzeDiabetesTrend(List<int> predictions) {
    final recent = predictions.length >= 10 ? predictions.sublist(predictions.length - 10) : predictions;
    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final overallAvg = predictions.reduce((a, b) => a + b) / predictions.length;

    if (recentAvg < overallAvg - 0.3) return 'Improving';
    if (recentAvg > overallAvg + 0.3) return 'Getting Worse';
    return 'Stable';
  }

  // Close the model after inference (optional if you want to free up resources)
  static void closeModels() {
    if (_diabetesInterpreter != null) {
      _diabetesInterpreter.close();
      print("Interpreter closed.");
    }
  }
}
