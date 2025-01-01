import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../models/vitals.dart';
import 'vital_indicator.dart';

class VitalsDataStream extends StatelessWidget {
  const VitalsDataStream({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorData = context.watch<SensorProvider>();

    return StreamBuilder<Vitals>(
      stream: sensorData.vitalsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final vitals = snapshot.data!;
        return Column(
          children: [
            VitalIndicator(
              label: 'Heart Rate',
              value: '${vitals.heartRate}',
              unit: 'BPM',
              icon: Icons.favorite,
            ),
            VitalIndicator(
              label: 'Blood Pressure',
              value: vitals.bloodPressure,
              unit: 'mmHg',
              icon: Icons.height,
            ),
            VitalIndicator(
              label: 'Temperature',
              value: vitals.temperature.toStringAsFixed(1),
              unit: '°C',
              icon: Icons.thermostat,
            ),
          ],
        );
      },
    );
  }
}
