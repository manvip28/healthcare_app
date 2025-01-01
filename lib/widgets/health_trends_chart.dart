import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';

class HealthTrendsChart extends StatelessWidget {
  const HealthTrendsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final vitalsData = context.watch<SensorProvider>().vitalsHistory;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: vitalsData.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.heartRate.toDouble());
              }).toList(),
              isCurved: true,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
