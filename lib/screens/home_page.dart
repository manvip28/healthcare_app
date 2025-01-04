import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/appointment_reminder_widget.dart';
import '../widgets/patient_list_widget.dart';
import '../providers/patient_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load appointments as soon as the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientProvider>(context, listen: false).loadAppointments();
    });
  }

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
                // Show Appointment Reminder Widget directly
                Consumer<PatientProvider>(
                  builder: (context, patientProvider, child) {
                    return patientProvider.appointments.isNotEmpty
                        ? const AppointmentReminderWidget()
                        : const SizedBox.shrink();  // If no appointments, show nothing
                  },
                ),
                const SizedBox(height: 16),
                // Show Patient List
                const PatientListWidget(),
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
