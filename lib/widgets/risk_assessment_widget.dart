import 'package:flutter/material.dart';
import '../services/risk_assessment_service.dart' as riskService;
import '../models/vitals.dart';

class RiskAssessmentWidget extends StatelessWidget {
  final Vitals vitals;

  const RiskAssessmentWidget({
    super.key,
    required this.vitals,
  });

  @override
  Widget build(BuildContext context) {
    // Use the correct RiskAssessment service to assess the risk
    final assessment = riskService.RiskAssessment.assessRisk(vitals);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Risk Assessment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (assessment.alerts.isNotEmpty) ...[
              for (String alert in assessment.alerts)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          alert,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
            ],

            _buildRiskMeter(
              'Heart Attack Risk',
              assessment.heartAttackRiskScore,
            ),
            const SizedBox(height: 16),
            _buildRiskMeter(
              'Hypoglycemic Shock Risk',
              assessment.hypoglycemicRiskScore,
            ),

            if (assessment.isHighRisk) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showEmergencyDialog(context);
                  },
                  child: const Text('Contact Emergency Services'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRiskMeter(String title, double riskPercentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: riskPercentage / 100,
          minHeight: 10,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getRiskColor(riskPercentage),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${riskPercentage.toStringAsFixed(1)}% Risk Level',
          style: TextStyle(
            color: _getRiskColor(riskPercentage),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getRiskColor(double percentage) {
    if (percentage < 30) return Colors.green;
    if (percentage < 60) return Colors.orange;
    return Colors.red;
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency Services'),
          content: const Text(
            'Would you like to call emergency services now? This is recommended given your current symptoms.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Call Emergency'),
              onPressed: () {
                // TODO: Implement emergency call functionality
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
