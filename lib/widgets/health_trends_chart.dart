// lib/widgets/health_trends_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/sensor_provider.dart';

class HealthTrendsChart extends StatelessWidget {
  HealthTrendsChart({super.key}); // Removed const constructor

  final dateFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final vitalsData = context.watch<SensorProvider>().vitalsHistory;

    if (vitalsData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 10,
            verticalInterval: 1,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < vitalsData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        dateFormat.format(vitalsData[value.toInt()].dateTime), // Use dateTime getter
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: vitalsData.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.heartRate.toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: Colors.red,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.1)),
            ),
            LineChartBarData(
              spots: vitalsData.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.temperature * 3, // Scaled for visibility
                );
              }).toList(),
              isCurved: true,
              color: Colors.orange,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.orange.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }
}