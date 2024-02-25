import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutMiddlewarePage extends StatefulWidget {
  final String itemId;
  final String userId;
  final String businessId;
  final DateTime timestamp;
  final int points;

  CheckoutMiddlewarePage({
    required this.itemId,
    required this.userId,
    required this.businessId,
    required this.timestamp,
    required this.points,
  });

  @override
  _CheckoutMiddlewarePageState createState() => _CheckoutMiddlewarePageState();
}

class _CheckoutMiddlewarePageState extends State<CheckoutMiddlewarePage> {
  double amount = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String itemName = '';  // Add a variable to store the item name
  String bisName = '';  // Add a variable to store the item name
  String userName = '';  // Add a variable to store the item name




  @override
  void initState() {
    super.initState();
    fetchItemName();  // Fetch the item name when the widget initializes
  }

  void fetchItemName() {
    // Fetch item details
    FirebaseFirestore.instance.collection('item_category').doc(widget.itemId).get().then((itemDoc) {
      if (itemDoc.exists) {
        setState(() {
          itemName = itemDoc.data()?['name'] ?? 'Unknown Item';
        });
      } else {
        print('Item document not found');
      }
    }).catchError((itemError) {
      print('Error fetching item document: $itemError');
    });

    FirebaseFirestore.instance.collection('businesses').doc(widget.businessId).get().then((itemDoc) {
      if (itemDoc.exists) {
        setState(() {
          bisName = itemDoc.data()?['firstName'] ?? 'Unknown Business';
        });
      } else {
        print('Businesses document not found');
      }
    }).catchError((itemError) {
      print('Error fetching businesses document: $itemError');
    });

    FirebaseFirestore.instance.collection('users').doc(widget.userId).get().then((itemDoc) {
      if (itemDoc.exists) {
        setState(() {
          userName = itemDoc.data()?['firstname'] ?? 'Unknown User';
        });
      } else {
        print('User document not found');
      }
    }).catchError((itemError) {
      print('Error fetching user document: $itemError');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Checkout Middleware'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Claim your points in the next order!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Item name: $itemName'),
              Text('User name: ${userName}'),
              Text('Business name: ${bisName}'),
              Text('Date & Time: ${widget.timestamp}'),
              Text('Points: ${widget.points}'),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount in AUD',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveToTransactionCollection();
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveToTransactionCollection() {
    FirebaseFirestore.instance.collection('users').doc(widget.userId).get().then((userDoc) {
      if (userDoc.exists) {
        if (userDoc.data()?['points_gained'] == null) {
          userDoc.reference.update({'points_gained': 0});
        }

        int currentPoints = userDoc.data()?['points_gained'] ?? 0;
        int updatedPoints = currentPoints + widget.points;

        FirebaseFirestore.instance.collection('transactions').add({
          'userId': widget.userId,
          'itemId': widget.itemId,
          'businessId': widget.businessId,
          'timestamp': widget.timestamp,
          'points': widget.points,
          'amount': amount,
        }).then((transactionDoc) {
          print('Transaction saved successfully!');
          userDoc.reference.update({'points_gained': updatedPoints});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transaction successful'),
              backgroundColor: Colors.green,
            ),
          );

        }).catchError((transactionError) {
          print('Error saving transaction: $transactionError');
        });
      } else {
        print('User document not found');
      }
    }).catchError((userError) {
      print('Error fetching user document: $userError');
    });
  }
}
