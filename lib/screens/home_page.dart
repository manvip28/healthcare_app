import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/patient_list_widget.dart';
import '../widgets/risk_assessment_widget.dart';
import '../widgets/widgets.dart';  // Ensure this import is correct
import '../providers/patient_provider.dart' ;  // Import your PatientProvider

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Healthcare Dashboard')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VitalsMonitorWidget(),
                const SizedBox(height: 16),
                // Use Consumer to access PatientProvider and build the widget
                Consumer<PatientProvider>(
                  builder: (context, patientProvider, child) {
                    return PatientListWidget();  // No need to pass the provider explicitly
                  },
                ),
                const SizedBox(height: 16),
                const RiskAssessmentWidget(),  // Assuming this widget exists
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-patient'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
