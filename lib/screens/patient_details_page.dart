import 'package:flutter/material.dart';
import 'package:healthcare_app/models/medical_record.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_app/models/patient.dart';
import 'package:healthcare_app/models/vitals.dart';
import '../providers/patient_provider.dart';
import '../widgets/form/appointment_form.dart';
import '../widgets/patient_tabs/patient_appointments_tab.dart';
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

    if (!context.read<PatientProvider>().areVitalsLoaded()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PatientProvider>().loadVitals();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = context.watch<PatientProvider>().getPatient(widget.patientId);

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: 'Overview / \n ओवरव्यू'),
                Tab(text: 'Vitals / \n महत्त्वपूर्ण संकेत'),
                Tab(text: 'Records / \n रिकॉर्ड्स'),
                Tab(text: 'Appointments / \n अपॉइंटमेंट्स'),
              ],
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontSize: 14),
              indicatorColor: Colors.blue,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PatientOverviewTab(patient: patient),
                  Stack(
                    children: [
                      PatientVitalsTab(patient: patient),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 160,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: TextButton.icon(
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
                                        child: VitalsEntryForm(
                                          patientId: patient.id,
                                          onSave: (vitals) {
                                            context.read<PatientProvider>().addVitalsForPatient(patient, vitals);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add_chart, color: Colors.deepPurple),
                                  label: Column(
                                    children: const [
                                      Text("Add Vitals", style: TextStyle(color: Colors.deepPurple, fontSize: 14)),
                                      Text("महत्त्वपूर्ण संकेत जोड़ें", style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      PatientRecordsTab(patient: patient),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 160,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: TextButton.icon(
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
                                          patientId: patient.id,
                                          onSave: (MedicalRecord record) {
                                            context.read<PatientProvider>().addMedicalRecord(record);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.note_add, color: Colors.deepPurple),
                                  label: Column(
                                    children: const [
                                      Text("Add Record", style: TextStyle(color: Colors.deepPurple, fontSize: 14)),
                                      Text("रिकॉर्ड जोड़ें", style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      PatientAppointmentsTab(patient: patient),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 160,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: TextButton.icon(
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
                                        child: AppointmentForm(
                                          patientId: patient.id,
                                          onSave: (appointment) {
                                            context.read<PatientProvider>().addAppointment(appointment);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                                  label: Column(
                                    children: const [
                                      Text("       Add \n Appointment", style: TextStyle(color: Colors.deepPurple, fontSize: 14)),
                                      Text("अपॉइंटमेंट जोड़ें", style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
