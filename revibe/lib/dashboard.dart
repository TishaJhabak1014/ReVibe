import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DashboardPage extends StatelessWidget {
  final String userName;

  DashboardPage({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $userName!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Display the list of items
            ItemList(),
            const SizedBox(height: 16),
            // Generate QR code
            // Container(
            //   height: 200.0, // Set the desired height for the QR code
            //   child: QrImage(
            //     data: 'Your concatenated userID and itemID here',
            //     version: QrVersions.auto,
            //     size: 200.0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('scannable_items_org').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var querySnapshot = snapshot.data!;
        var items = querySnapshot.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Display each item in the list
            for (var item in items)
              InkWell(
                onTap: () {
                  // Show a snackbar when the item is clicked
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your scan for ${item['name']} is ready!'),
                      duration: Duration(minutes: 5),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    item['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Points: ${item['points']}'),
                ),
              ),
          ],
        );
      },
    );
  }
}
