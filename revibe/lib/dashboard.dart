import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DashboardPage extends StatelessWidget {
  final String userName;
  final String userID;

  DashboardPage({required this.userName, required this.userID});

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
            ItemList(userID: userID),
          ],
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final String userID;

  ItemList({required this.userID});

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
                  String documentID = item.id;

                  // print('$userID|$item.id');
                  // Navigate to a new screen with QR code and message
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRScreen(
                        userID : userID,
                        itemID: item.id, // here should be the document id for tehta item in te firebase 
                        itemName: item['name'],
                        itemPoints: item['points'],
                      ),
                    ),
                    
                  );
                  // print('$userID|$documentID');
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

class QRScreen extends StatelessWidget {
  final String userID;
  final String itemName;
  final int itemPoints;
  final String itemID;

  QRScreen({required this.userID, required this.itemID, required this.itemName, required this.itemPoints});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your scan for $itemName is ready!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Display the QR code
            QrImageView(
              data: '$userID|$itemID', // Concatenate userName and itemID
              size: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}

