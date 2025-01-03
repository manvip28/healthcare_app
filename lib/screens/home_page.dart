import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/patient_list_widget.dart';
import '../widgets/risk_assessment_widget.dart';
import '../widgets/vitals_monitor_widget.dart'; // Correct import for VitalsMonitorWidget
import '../providers/patient_provider.dart'; // Ensure PatientProvider is correctly imported

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
                Consumer<PatientProvider>(
                  builder: (context, patientProvider, child) {
                   return const PatientListWidget();
                  },
                ),
                const SizedBox(height: 16),
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
