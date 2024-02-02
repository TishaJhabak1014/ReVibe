import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BisDashboard extends StatefulWidget {
  final String businessId;

  BisDashboard({required this.businessId});

  @override
  _BisDashboardState createState() => _BisDashboardState();
}

class _BisDashboardState extends State<BisDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ScannableItem> scannableItems = [];
  int? businessPointThreshold;

  @override
  void initState() {
    super.initState();
    _fetchScannableItems(); // Fetch items when the widget is first inserted
    _fetchBusinessPointThreshold(); //
    
  }


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
            
            if (businessPointThreshold != null)
              _buildMetricSettingTile(businessPointThreshold!),
            
            Visibility(
              visible: businessPointThreshold == null,
              child: ElevatedButton(
                onPressed: () {
                  _editBusinessPointThresholdDialog();
                },
                child: const Text('Add Point Threshold'),
              ),
            ),

            const SizedBox(height: 16.0), // Add some spacing
            ElevatedButton(
              onPressed: () {
                _addScannableItemDialog();
              },
              child: const Text('Add Scannable Item'),
            ),
            const SizedBox(height: 16.0), // Add some spacing
            

            //
            // ElevatedButton(
            //   onPressed: () {
            //     _addScannableItemDialog();
            //   },
            //   child: const Text('Add Scannable Item'),
            // ),
            // Display added scannable items
            for (int index = 0; index < scannableItems.length; index++)
              _buildScannableItemTile(scannableItems[index], index),
          ],
        ),
      ),
    );
  }

Widget _buildMetricSettingTile(int pointThreshold) {
  TextEditingController pointThresholdController =
      TextEditingController(text: pointThreshold.toString());

  return ListTile(
    title: Row(
      children: [
        Expanded(
          child: Text('1 dollar is rewarded per $pointThreshold points'),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _editBusinessPointThresholdDialog();
          },
        ),
      ],
    ),
  );
}

  Widget _buildScannableItemTile(ScannableItem item, int index) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(item.name),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editScannableItem(item.id);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteScannableItem(item.id);
            },
          ),
        ],
      ),
      subtitle: Text('Points: ${item.points}'),
    );
  }

  Future<void> _addScannableItemDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController pointsController = TextEditingController();

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
              onPressed: () async {
                // Validate and add the scannable item
                if (nameController.text.isNotEmpty && pointsController.text.isNotEmpty) {
                  ScannableItem newItem = ScannableItem(
                    id: '', // Provide an empty string for id
                    businessId: widget.businessId,
                    name: nameController.text,
                    points: int.parse(pointsController.text),
                  );

                  await _saveScannableItem(newItem);
                  _fetchScannableItems(); // Refresh the list
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

  Future<void> _saveScannableItem(ScannableItem item) async {
    await _firestore.collection('scannable_items_org').add({
      'businessId': item.businessId,
      'name': item.name,
      'points': item.points,
    });
  }

  void _deleteScannableItem(String itemId) {
    _firestore.collection('scannable_items_org').doc(itemId).delete();
    _fetchScannableItems(); // Refresh the list
  }

  Future<void> _fetchScannableItems() async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('scannable_items_org')
      .where('businessId', isEqualTo: widget.businessId)
      .get();
  setState(() {
      scannableItems = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ScannableItem(
          id: doc.id,
          businessId: data['businessId'],
          name: data['name'],
          points: data['points'],
        );
      }).toList();
    });
  }

  Future<void> _editScannableItem(String itemId) async {
  // Fetch the existing item data
  ScannableItem existingItem = scannableItems.firstWhere((item) => item.id == itemId);

  // Create controllers and set initial values
  TextEditingController nameController = TextEditingController(text: existingItem.name);
  TextEditingController pointsController = TextEditingController(text: existingItem.points.toString());

  // Show the dialog
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Scannable Item'),
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
            onPressed: () async {
              // Validate and update the scannable item
              if (nameController.text.isNotEmpty && pointsController.text.isNotEmpty) {
                ScannableItem updatedItem = ScannableItem(
                  id: itemId,
                  businessId: widget.businessId,
                  name: nameController.text,
                  points: int.parse(pointsController.text),
                );

                await _updateScannableItem(updatedItem);
                _fetchScannableItems(); // Refresh the list
                Navigator.pop(context);
              }
            },
            child: Text('Update'),
          ),
        ],
      );
    },
  );
}

Future<void> _updateScannableItem(ScannableItem item) async {
  await _firestore.collection('scannable_items_org').doc(item.id).update({
    'name': item.name,
    'points': item.points,
  });
}



// new
Future<void> _editBusinessPointThresholdDialog() async {
    TextEditingController pointThresholdController =
        TextEditingController(text: businessPointThreshold?.toString() ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Point Threshold'),
          content: Column(
            children: [
              TextField(
                controller: pointThresholdController,
                decoration: InputDecoration(labelText: 'Point Threshold'),
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
              onPressed: () async {
                if (pointThresholdController.text.isNotEmpty) {
                  int updatedPointThreshold = int.parse(pointThresholdController.text);
                  await _updateBusinessPointThreshold(updatedPointThreshold);
                  _fetchBusinessPointThreshold(); // Refresh the point threshold
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchBusinessPointThreshold() async {
    DocumentSnapshot documentSnapshot = await _firestore.collection('businesses').doc(widget.businessId).get();
    if (documentSnapshot.exists) {
      setState(() {
        businessPointThreshold = documentSnapshot['point_threshold'];
      });
    } else {
      setState(() {
        businessPointThreshold = null;
      });
    }
  }

  Future<void> _updateBusinessPointThreshold(int pointThreshold) async {
    await _firestore.collection('businesses').doc(widget.businessId).update({
      'point_threshold': pointThreshold,
    });
  }


}



class ScannableItem {
  late String id;
  final String businessId;
  final String name;
  final int points;

  ScannableItem({
    required this.id,
    required this.businessId,
    required this.name,
    required this.points,
  });

  // Constructor without the id parameter
  ScannableItem.withoutId({
    required this.businessId,
    required this.name,
    required this.points,
  });
}

