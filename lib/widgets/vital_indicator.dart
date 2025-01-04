import 'package:flutter/material.dart';

class VitalIndicator extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  const VitalIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text('$label: $value $unit'),
    );
  }
}
