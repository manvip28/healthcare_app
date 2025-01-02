import 'package:healthcare_app/models/vitals.dart';

class RiskAssessment {
  static const int MINIMUM_SYMPTOMS_FOR_ALERT = 3;
  static const int HIGH_HEART_RATE_THRESHOLD = 100;
  static const int LOW_BLOOD_SUGAR_THRESHOLD = 70;
  static const int HEART_RATE_RISK_WEIGHT = 40;
  static const int SYMPTOM_RISK_WEIGHT = 20;

  static AssessmentResult assessRisk(Vitals vitals) {
    if (vitals == null) {
      throw ArgumentError("Vitals data cannot be null");
    }

    bool isHighRisk = false;
    List<String> alerts = [];

    // Count active heart attack symptoms
    int heartAttackSymptomCount = vitals.heartAttackSymptoms.values
        .where((isPresent) => isPresent)
        .length;

    // Count active hypoglycemic symptoms
    int hypoglycemicSymptomCount = vitals.hypoglycemicSymptoms.values
        .where((isPresent) => isPresent)
        .length;

    // Check for heart attack risk
    if (heartAttackSymptomCount >= MINIMUM_SYMPTOMS_FOR_ALERT &&
        vitals.heartRate > HIGH_HEART_RATE_THRESHOLD) {
      isHighRisk = true;
      alerts.add(
          'WARNING: High risk of heart attack detected. Please seek immediate medical attention.');
    }

    // Check for hypoglycemic shock risk
    int bloodSugar = int.tryParse(vitals.bloodSugar) ?? 0;
    if (hypoglycemicSymptomCount >= MINIMUM_SYMPTOMS_FOR_ALERT &&
        bloodSugar < LOW_BLOOD_SUGAR_THRESHOLD) {
      isHighRisk = true;
      alerts.add(
          'WARNING: Risk of hypoglycemic shock detected. Please seek immediate medical attention.');
    }

    return AssessmentResult(
      isHighRisk: isHighRisk,
      alerts: alerts,
      heartAttackRiskScore: _calculateHeartAttackRiskScore(vitals, heartAttackSymptomCount),
      hypoglycemicRiskScore: _calculateHypoglycemicRiskScore(vitals, hypoglycemicSymptomCount),
    );
  }

  static double _calculateHeartAttackRiskScore(Vitals vitals, int symptomCount) {
    double score = 0;
    score += (vitals.heartRate > HIGH_HEART_RATE_THRESHOLD) ? HEART_RATE_RISK_WEIGHT : 0;
    score += (symptomCount * SYMPTOM_RISK_WEIGHT);
    return score.clamp(0.0, 100.0);
  }

  static double _calculateHypoglycemicRiskScore(Vitals vitals, int symptomCount) {
    double score = 0;
    int bloodSugar = int.tryParse(vitals.bloodSugar) ?? 0;
    score += (bloodSugar < LOW_BLOOD_SUGAR_THRESHOLD) ? HEART_RATE_RISK_WEIGHT : 0;
    score += (symptomCount * SYMPTOM_RISK_WEIGHT);
    return score.clamp(0.0, 100.0);
  }
}

class AssessmentResult {
  final bool isHighRisk;
  final List<String> alerts;
  final double heartAttackRiskScore;
  final double hypoglycemicRiskScore;

  AssessmentResult({
    required this.isHighRisk,
    required this.alerts,
    required this.heartAttackRiskScore,
    required this.hypoglycemicRiskScore,
  });
}
