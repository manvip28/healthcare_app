// lib/screens/vitals_monitor_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../widgets/vital_card.dart';
import '../widgets/health_trends_chart.dart';
import '../models/vitals.dart';

class VitalsMonitorPage extends StatelessWidget {
  const VitalsMonitorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorData = context.watch<SensorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Vitals Monitor')),
      body: StreamBuilder<Vitals>(
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
              ),
              const HealthTrendsChart(),
            ],
          );
        },
      ),
    );
  }
}