// lib/widgets/vitals_data_stream.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../models/vitals.dart';
import 'vital_card.dart';

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
            VitalCard(
              title: 'Heart Rate',
              value: '${vitals.heartRate} BPM',
              icon: Icons.favorite,
              color: _getHeartRateColor(vitals.heartRate),
            ),
            VitalCard(
              title: 'Blood Pressure',
              value: vitals.bloodPressure,
              icon: Icons.health_and_safety,
            ),
            VitalCard(
              title: 'Temperature',
              value: '${vitals.temperature.toStringAsFixed(1)}°C',
              icon: Icons.thermostat,
              color: _getTemperatureColor(vitals.temperature),
            ),
          ],
        );
      },
    );
  }

  Color _getHeartRateColor(int heartRate) {
    if (heartRate < 60) return Colors.blue;
    if (heartRate > 100) return Colors.red;
    return Colors.green;
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 36.1) return Colors.blue;
    if (temperature > 37.8) return Colors.red;
    return Colors.green;
  }
}
