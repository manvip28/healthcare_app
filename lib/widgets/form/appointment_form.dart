// widgets/form/appointment_form.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/appointment.dart';

class AppointmentForm extends StatefulWidget {
  final String patientId;
  final Function(Appointment) onSave;

  const AppointmentForm({
    super.key,
    required this.patientId,
    required this.onSave,
  });

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _purposeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(_selectedDate == null
                ? 'Select Date / तारीख़ चुनें'
                : DateFormat('MMM dd, yyyy').format(_selectedDate!)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
          ),
          ListTile(
            title: Text(_selectedTime == null
                ? 'Select Time / समय चुनें'
                : _selectedTime!.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() => _selectedTime = time);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose / उद्देश्य',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the purpose / कृपया उद्देश्य दर्ज करें';
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  _selectedDate != null &&
                  _selectedTime != null) {
                final dateTime = DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                  _selectedTime!.hour,
                  _selectedTime!.minute,
                );

                final appointment = Appointment(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  patientId: widget.patientId,
                  dateTime: dateTime,
                  purpose: _purposeController.text,
                );

                widget.onSave(appointment);
                Navigator.pop(context);
              }
            },
            child: const Text('Save Appointment / अपॉइंटमेंट सेव करें'),
          ),
        ],
      ),
    );
  }
}
