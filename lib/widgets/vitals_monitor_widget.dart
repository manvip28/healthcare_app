import 'package:flutter/material.dart';
import 'vitals_data_stream.dart';

class VitalsMonitorWidget extends StatelessWidget {
  const VitalsMonitorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Vitals',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const VitalsDataStream(),
          ],
        ),
      ),
    );
  }
}
