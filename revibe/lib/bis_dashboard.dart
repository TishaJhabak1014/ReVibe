import 'package:flutter/material.dart';

class BisDashboard extends StatefulWidget {
  @override
  _BisDashboardState createState() => _BisDashboardState();
}

class _BisDashboardState extends State<BisDashboard> {
  List<ScannableItem> scannableItems = []; // Store added scannable items

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _addScannableItemDialog(); // Open a dialog to add scannable items
              },
              child: const Text('Add Scannable Item'),
            ),
            // Display added scannable items
            for (ScannableItem item in scannableItems)
              ListTile(
                title: Text(item.name),
                subtitle: Text('Points: ${item.points} - Equivalent Dollar: ${item.equivalentDollar}'),
              ),
          ],
        ),
      ),
    );
  }

  // Function to add scannable items
  Future<void> _addScannableItemDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController pointsController = TextEditingController();
    TextEditingController equivalentDollarController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Scannable Item'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: pointsController,
                decoration: InputDecoration(labelText: 'Points'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: equivalentDollarController,
                decoration: InputDecoration(labelText: 'Equivalent Dollar'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Validate and add the scannable item
                if (nameController.text.isNotEmpty &&
                    pointsController.text.isNotEmpty &&
                    equivalentDollarController.text.isNotEmpty) {
                  setState(() {
                    scannableItems.add(
                      ScannableItem(
                        name: nameController.text,
                        points: int.parse(pointsController.text),
                        equivalentDollar: double.parse(equivalentDollarController.text),
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

// Model for scannable items
class ScannableItem {
  final String name;
  final int points;
  final double equivalentDollar;

  ScannableItem({
    required this.name,
    required this.points,
    required this.equivalentDollar,
  });
}
