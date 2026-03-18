import 'package:flutter/material.dart';

class EquipmentScreen extends StatelessWidget {
  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipment Pool"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          EquipmentCard(
            name: "Football",
            status: "Available",
          ),
          EquipmentCard(
            name: "Cricket Kit",
            status: "In Use",
          ),
        ],
      ),
    );
  }
}

class EquipmentCard extends StatelessWidget {
  final String name;
  final String status;

  const EquipmentCard({
    super.key,
    required this.name,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(name),
        subtitle: Text("Status: $status"),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text("Request"),
        ),
      ),
    );
  }
}
