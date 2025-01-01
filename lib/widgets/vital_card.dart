import 'package:flutter/material.dart';

class VitalCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const VitalCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
