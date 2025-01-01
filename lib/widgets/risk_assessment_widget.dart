import 'package:flutter/material.dart';

class RiskAssessmentWidget extends StatelessWidget {
  const RiskAssessmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Based on the patient\'s vitals, we can assess their health risks.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Trigger some risk assessment logic here
                // For example, navigate to a detailed risk assessment page
                Navigator.pushNamed(context, '/risk-assessment');
              },
              child: const Text('Assess Risk'),
            ),
          ],
        ),
      ),
    );
  }
}
