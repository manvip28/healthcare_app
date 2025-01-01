import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../widgets/patient_tabs/patient_overview_tab.dart';
import '../widgets/patient_tabs/patient_vitals_tab.dart';
import '../widgets/patient_tabs/patient_records_tab.dart';

class PatientDetailsPage extends StatelessWidget {
  final String patientId;

  const PatientDetailsPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final patient = context.watch<PatientProvider>().getPatient(patientId);

    return Scaffold(
      appBar: AppBar(title: Text(patient.name)),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Vitals'),
                Tab(text: 'Records'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PatientOverviewTab(patient: patient),
                  PatientVitalsTab(patient: patient),
                  PatientRecordsTab(patient: patient),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
