import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/patient.dart';
import '../../providers/patient_provider.dart';

class PatientAppointmentsTab extends StatelessWidget {
  final Patient patient;

  const PatientAppointmentsTab({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(
      builder: (context, provider, child) {
        final appointments = provider.getPatientAppointments(patient.id);

        if (appointments.isEmpty) {
          return const Center(
            child: Text(
              'No appointments scheduled / \n कोई अपॉइंटमेंट निर्धारित नहीं है।',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), // Increased font size
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(
                  DateFormat('MMM dd, yyyy HH:mm').format(appointment.dateTime),
                ),
                subtitle: Text(appointment.purpose),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Show confirmation dialog before deleting
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text('Are you sure you want to delete this appointment?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        ) ?? false;

                        if (shouldDelete) {
                          await provider.deleteAppointment(appointment);
                        }
                      },
                      child: const Text('Delete Appointment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button color
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
