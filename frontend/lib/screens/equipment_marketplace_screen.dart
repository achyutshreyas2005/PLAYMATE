import 'package:flutter/material.dart';
import '../services/equipment_service.dart';
import '../models/equipment.dart';
import 'add_equipment_screen.dart';

class EquipmentMarketplaceScreen extends StatefulWidget {
  const EquipmentMarketplaceScreen({Key? key}) : super(key: key);

  @override
  _EquipmentMarketplaceScreenState createState() => _EquipmentMarketplaceScreenState();
}

class _EquipmentMarketplaceScreenState extends State<EquipmentMarketplaceScreen> {
  final EquipmentService _equipmentService = EquipmentService();
  List<Equipment> _equipmentList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEquipment();
  }

  Future<void> _loadEquipment() async {
    setState(() {
      _isLoading = true;
    });

    List<Equipment> items = await _equipmentService.getEquipment();

    if (mounted) {
      setState(() {
        _equipmentList = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _buyEquipment(String id) async {
    bool success = await _equipmentService.buyEquipment(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success ? "Purchase Successful!" : "Purchase Failed."),
        backgroundColor: success ? Colors.green : Colors.red,
      ));
      if (success) _loadEquipment(); // refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EQUIPMENT',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _loadEquipment();
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _equipmentList.isEmpty
              ? const Center(child: Text("No equipment available right now."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _equipmentList.length,
                  itemBuilder: (context, index) {
                    final item = _equipmentList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName.toUpperCase(),
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("${item.sportType} • ${item.condition}",
                                      style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                                      border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "\$${item.price.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _buyEquipment(item.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text("BUY", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEquipmentScreen()),
          );
          if (result == true) {
            _loadEquipment();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
