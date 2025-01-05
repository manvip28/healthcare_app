import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/appointment.dart';
import '../models/patient.dart';
import '../providers/patient_provider.dart';

class AppointmentReminderWidget extends StatelessWidget {
  const AppointmentReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(
      builder: (context, provider, child) {
        final allPatients = provider.patients;
        print('All patients: $allPatients');  // Debugging line

        final upcomingAppointments = allPatients
            .map((patient) {
          final nextAppointment = provider.getNextAppointment(patient.id);
          if (nextAppointment != null) {
            return {'patient': patient, 'appointment': nextAppointment};
          }
          return null;
        })
            .where((element) => element != null)
            .toList();

        print('Upcoming Appointments: $upcomingAppointments');  // Debugging line

        if (upcomingAppointments.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No upcoming appointments'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Upcoming Appointments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Add a widget that rebuilds when data changes
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingAppointments.length,
              itemBuilder: (context, index) {
                final appointment = upcomingAppointments[index]!;  // Non-nullable
                final patient = appointment['patient'] as Patient;
                final nextAppointment = appointment['appointment'] as Appointment;

                return Card(
                  child: ListTile(
                    title: Text(patient.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age: ${patient.age}'),
                        Text(
                          'Next Appointment: ${DateFormat('MMM dd, yyyy HH:mm').format(nextAppointment.dateTime)}',
                        ),
                        Text('Purpose: ${nextAppointment.purpose}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
