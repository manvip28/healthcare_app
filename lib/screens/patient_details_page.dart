import 'package:flutter/material.dart';
import 'package:healthcare_app/models/medical_record.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_app/models/patient.dart';
import 'package:healthcare_app/models/vitals.dart';
import '../providers/patient_provider.dart';
import '../widgets/patient_tabs/patient_overview_tab.dart';
import '../widgets/patient_tabs/patient_vitals_tab.dart';
import '../widgets/patient_tabs/patient_records_tab.dart';
import '../widgets/form/vitals_entry_form.dart';
import '../widgets/form/medical_record_form.dart';

class PatientDetailsPage extends StatefulWidget {
  final String patientId;

  const PatientDetailsPage({super.key, required this.patientId});

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  @override
  void initState() {
    super.initState();

    // Load vitals only if they are not already loaded
    if (!context.read<PatientProvider>().areVitalsLoaded()) {
      // Ensure vitals are loaded when the page is first created
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PatientProvider>().loadVitals(); // Make sure vitals are loaded after the first frame
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = context.watch<PatientProvider>().getPatient(widget.patientId);

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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Floating action button to add vitals
          FloatingActionButton(
            heroTag: 'addVitals',
            onPressed: () {
              // Show the form to add vitals
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: VitalsEntryForm(
                    patientId: patient.id, // Pass patientId here
                    onSave: (Vitals vitals) {
                      // Save vitals for the current patient
                      context.read<PatientProvider>().addVitalsForPatient(patient, vitals);
                    },
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          // Floating action button to add medical record
          FloatingActionButton(
            heroTag: 'addMedicalRecord',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: MedicalRecordForm(
                    patientId: patient.id, // Pass patientId here
                    onSave: (MedicalRecord record) {
                      // Save the medical record
                      context.read<PatientProvider>().addMedicalRecord(record);
                    },
                  ),
                ),
              );
            },
            child: const Icon(Icons.note_add),
          ),
        ],
      ),
    );
  }
}
