import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_app/providers/patient_provider.dart';

class PatientListWidget extends StatelessWidget {
  const PatientListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return SizedBox(
      height: 500,  // Define height for the ListView
      child: ListView.builder(
        itemCount: patientProvider.patientsList.length,
        itemBuilder: (context, index) {
          final patient = patientProvider.patientsList[index];
          return ListTile(
            title: Text(patient.name),
            onTap: () {
              // Navigate to the patient's details page
              Navigator.pushNamed(context, '/patient-details', arguments: patient.id);
            },
          );
        },
      ),
    );
  }
}
