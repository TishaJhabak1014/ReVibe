import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:revibe/bis_change.dart';
import 'main.dart';
import 'CheckoutMiddlewarePage.dart';
import 'package:intl/intl.dart'; 

class BisDashboard extends StatefulWidget {
  final String businessId;

  BisDashboard({required this.businessId});

  @override
  _BisDashboardState createState() => _BisDashboardState();
}

class _BisDashboardState extends State<BisDashboard> {

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
      ),
      bottomNavigationBar: NavigationBar(businessID: widget.businessId, ),
    );
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













// Navigation Bar Layout
class NavigationBar extends StatelessWidget {
  final String businessID;

  const NavigationBar({required this.businessID});

  @override
  Widget build(BuildContext context) {
    return Navigation(businessID: businessID,);
  }
}

// Navigation State
class Navigation extends StatefulWidget {
  final String businessID;

  Navigation({Key? key, required this.businessID}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}


// Navigation Logic
class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Item',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Collaborator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

        ],
        currentIndex: currentPageIndex,
        selectedItemColor: Colors.blue, 
        unselectedItemColor: Colors.grey,
        
        
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),

      // Navigation Content
      body: Center(
        child: _buildPage(currentPageIndex, widget.businessID),
      ),

    );
  }
}


// Function to build content based on the selected index
Widget _buildPage(int index, String businessID) {
  switch (index) {
    case 0:
      return HomeContent(businessId: businessID,);
    case 1:
      return ItemContent(businessId: businessID,); 
    case 2:
      return TransactionContent(businessId: businessID,); 
    case 3:
      return CollaboratorContent(); 
    case 4:
      return ProfileContent(businessID);  
    default:
      return Container();
  }
}







class HomeContent extends StatefulWidget {
  final String businessId;
  
  // const HomeContent ({super.key, required this.businessId}) ;
  const HomeContent({Key? key, required this.businessId}) : super(key: key);


  @override
  _HomeContentState createState() => _HomeContentState();
}



class _HomeContentState extends State<HomeContent> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String scannedData = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Content'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScannerScreen(businessId: widget.businessId,)),
            );
          },
          child: const Text('Scan QR code'),
        ),
      ),
    );
  }
}


class QRScannerScreen extends StatefulWidget {
  final String businessId;
  
  const QRScannerScreen ({super.key, required this.businessId});
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String scannedData = '';
  bool isDisplayScreenShown = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, scannedData);
            },
            child: const Text('Close Scanner'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedData = scanData.code!;
        if (!isDisplayScreenShown) {
          isDisplayScreenShown = true;
          _navigateToDisplayScreen(scannedData);
        }
        controller.stopCamera();
      });
    });
  }

  void _navigateToDisplayScreen(String scannedData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayScannedDataScreen(scannedData: scannedData, businessId: widget.businessId),
      ),
    ).then((_) {
      isDisplayScreenShown = false;
    });

  

  }
}
class DisplayScannedDataScreen extends StatelessWidget {
  // final String scannedData;

  // const DisplayScannedDataScreen({Key? key, required this.scannedData})
  //     : super(key: key);

  final String scannedData;
  final String businessId;

  const DisplayScannedDataScreen({Key? key, required this.scannedData, required this.businessId})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<Map<String, dynamic>>(
              future: _parseScannedData(scannedData, businessId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data ?? {};

                  return Column(
                    children: [
                      Text(
                        'Firstname: ${data['firstname'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Points: ${data['points'] ?? 0}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Item Name: ${data['name'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutMiddlewarePage(
                                itemId: data['itemId'],
                                userId: data['userId'],
                                businessId: data['businessId'],
                                timestamp: data['timestamp'],
                                points: data['points'],
                              ),
                            ),
                          );
                        },
                        child: const Text('Proceed to Checkout'),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }


  static Future<Map<String, dynamic>> _parseScannedData(String scannedData, String businessId) async {
  final parts = scannedData.split('|');

  if (parts.length >= 2) {
    try {
      // Query the 'users' collection to get the firstname
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(parts[0]).get();

      if (!userDoc.exists) {
        return {'error': 'User not found'};
      }

      print("here"+ businessId + " "+parts[1] + " "+parts[0]+ " "+scannedData  );
      // Query the 'scannable_items_org' collection to get points and name
      var itemDoc = await FirebaseFirestore.instance
        .collection('scannable_items_org')
        .where('businessId', isEqualTo: businessId)
        .where('itemId', isEqualTo: parts[1])
        .get();


      // if (itemDoc.exists) {
      //   // Both user and item found, extract data
      //   return {
      //     'firstname': userDoc.data()?['firstname'] ?? 'Unknown',
      //     'points': itemDoc.data()?['points'] ?? 0,
      //     'name': itemDoc.data()?['name'] ?? 'Unknown',
      //     'itemId': parts[1],
      //     'userId': parts[0],
      //     'businessId': businessId,
      //     'timestamp': DateTime.now(),
      //     /**
      //      * .collection('scannable_items_org')
      //       .where('businessId', isEqualTo: widget.businessId)
      //       .snapshots(),
      //      */
      //   };
      // } else {
      //   return {'error': 'Item not found'};
      // }

      if (itemDoc.docs.isNotEmpty) {
        // Both user and item found, extract data
        var itemData = itemDoc.docs.first.data();
        return {
          'firstname': userDoc.data()?['firstname'] ?? 'Unknown',
          'points': itemData['points'] ?? 0,
          'name': itemData['name'] ?? 'Unknown',
          'itemId': parts[1],
          'userId': parts[0],
          'businessId': businessId,
          'timestamp': DateTime.now(),
        };
      } else {
        return {'error': 'Item not found'};
      }

    } catch (e) {
      return {'error': 'Error getting documents: $e'};
    }
  } else {
    return {'error': 'Error: Unable to parse scanned data.'};
  }
}

}



// String _parseScannedData(String scannedData) {
//   final parts = scannedData.split('|');

//   if (parts.length >= 2) {
//     return 'UserID: ${parts[0]}\nItemID: ${parts[1]}';
//   } else {
//     return 'Error: Unable to parse scanned data.';
//   }
// }
// **********

class ItemContent extends StatefulWidget {
  final String businessId;
  
  const ItemContent ({super.key, required this.businessId});

  @override
  _ItemContentState createState() => _ItemContentState();
}

class _ItemContentState extends State<ItemContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Content'),
      ),


      body: StreamBuilder<QuerySnapshot>(

        // check for items matching businessID
        stream: FirebaseFirestore.instance
            .collection('scannable_items_org')
            .where('businessId', isEqualTo: widget.businessId)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          var querySnapshot = snapshot.data!;
          var items = querySnapshot.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Padding(
                padding: EdgeInsets.all(20.0),

                // Text
                child: Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Add item button
              ElevatedButton(
                onPressed: () {
                  _showAddItem(context);
                },
                child: const Text('Add Item'),
              ),




              // Item list
              items.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          var itemName = item['name'];
                          var itemPoints = item['points'];

                          return InkWell(
                            onTap: () {
                              _showEditItem(context, item.id);
                            },
                            child: ListTile(
                              title: Text(
                                itemName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Points: $itemPoints'),
                            ),
                          );
                        },
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No items available.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }


  // change 
  Future<void> _showAddItem(BuildContext context) async {
    bool showTextField = false; 
    String dropdownvalue = 'Paper Cup';
    String selectedItemName = dropdownvalue;
    int itemPoints = 0;


    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('item_category')
          .get();

      List<String> itemCategories = []; // List to store item categories

      // Extract item categories from documents
      querySnapshot.docs.forEach((doc) {
        itemCategories.add(doc['name']);
      });


      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              // title
              title: const Text('Add New Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                 Row(
                  children: [
                    const Text(
                      'Item Category:', 
                      style: TextStyle(fontSize: 16), 
                    ),
                    const SizedBox(width: 10), 
                    DropdownButton<String>(
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: itemCategories.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                          showTextField = newValue == 'Others';
                          selectedItemName = newValue == 'Other' ? '' : newValue;
                        });
                      },
                    ),
                  ],
                ),

                // Conditionally show/hide the text field
                Visibility(
                  visible: showTextField,
                  child: Flexible(
                    child: TextField(
                     
                      onChanged: (value) {
                        setState(() {
                          selectedItemName = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Other Category',
                      ),
                    ),
                  ),
                ),

                TextField(
                  decoration: const InputDecoration(labelText: 'Item Points'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    itemPoints = int.tryParse(value) ?? 0;
                  },
                ),

                ],
              ),

              // user actions
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async{
                    print('Selected Item Name: $selectedItemName');
                    print('Item Points: $itemPoints');
                    String itemId;

                    if (dropdownvalue == "Others") {
                     itemId =  await _addItemCategoryToFirestore(selectedItemName) ?? '';   
                     _addItemToFirestore(selectedItemName, itemPoints, widget.businessId, itemId); 
                    }else{
                      itemId = await _findItemIdByCategoryName(selectedItemName) ?? '';
                    }

                    _addItemToFirestore(selectedItemName, itemPoints, widget.businessId, itemId);

                    // if (itemId != null) {
                    //   _addItemToFirestore(selectedItemName, itemPoints, widget.businessId, itemId);
                    // } else {
                    //   print('Error: Item not found');
                    // }

                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          });
        },
      );
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  // Function to show edit item dialog
  void _showEditItem(BuildContext context, String itemId) {
    FirebaseFirestore.instance.collection('scannable_items_org').doc(itemId).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String itemName = documentSnapshot['name'];
        int itemPoints = documentSnapshot['points'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Item Action'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(

                    // Edit 
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit'),
                    onTap: () {
                      Navigator.pop(context); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditItemPage(itemId: itemId, itemName: itemName, itemPoints: itemPoints),
                        ),
                      );
                    },
                  ),


                  // Delete
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      Navigator.pop(context); 
                      _deleteItem(itemId); 
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }


}

class EditItemPage extends StatefulWidget {
  final String itemId;
  final String itemName;
  final int itemPoints;

  EditItemPage({required this.itemId, required this.itemName, required this.itemPoints});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _nameController;
  late TextEditingController _pointsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.itemName);
    _pointsController = TextEditingController(text: widget.itemPoints.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,


            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                ),
              ),
              const SizedBox(height: 20),


              TextFormField(
                controller: _pointsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Item Points',
                ),
              ),
              const SizedBox(height: 20),


              ElevatedButton(
                onPressed: () {
                  // Handle saving changes here
                  String newName = _nameController.text;
                  int newPoints = int.tryParse(_pointsController.text) ?? 0;
                  _editItem(widget.itemId, newName, newPoints);
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionContent extends StatelessWidget {
  final String businessId;

  TransactionContent({required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Page'),
      ),
      body: TransactionDataTable(businessId: businessId),
    );
  }
}

class TransactionDataTable extends StatelessWidget {
  final String businessId;

  TransactionDataTable({required this.businessId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('transactions')
          .where('businessId', isEqualTo: businessId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No transactions available.'));
        }

        return FutureBuilder<List<DataRow>>(
          future: _buildRows(snapshot.data!.docs),
          builder: (context, AsyncSnapshot<List<DataRow>> rowsSnapshot) {
            if (rowsSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (rowsSnapshot.hasError) {
              return Center(child: Text('Error: ${rowsSnapshot.error}'));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('User Name')),
                  DataColumn(label: Text('Item Name')),
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('Points')),
                  DataColumn(label: Text('Amount')),
                  // Add other columns as needed
                ],
                rows: rowsSnapshot.data!,
              ),
            );
          },
        );
      },
    );
  }

  Future<List<DataRow>> _buildRows(List<QueryDocumentSnapshot> docs) async {
    List<DataRow> rows = [];

    for (QueryDocumentSnapshot doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Fetch associated data
      String userId = await fetchUserName(data['userId']);
      String itemName = await fetchItemName(data['itemId']);

      // Format the timestamp
      String formattedTimestamp =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(data['timestamp'].toDate());

      rows.add(
        DataRow(
          cells: [
            DataCell(Text(userId)),
            DataCell(Text(itemName)),
            DataCell(Text(formattedTimestamp)),
            DataCell(Text(data['points'].toString())),
            DataCell(Text(data['amount'].toString())),
            // Add other fields as needed
          ],
        ),
      );
    }

    return rows;
  }

  Future<String> fetchUserName(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc['firstname'];
    }
    return 'User Not Found';
  }

  Future<String> fetchBusinessName(String businessId) async {
    DocumentSnapshot businessDoc =
        await FirebaseFirestore.instance.collection('businesses').doc(businessId).get();
    if (businessDoc.exists) {
      return businessDoc['firstName'];
    }
    return 'Business Not Found';
  }

  Future<String> fetchItemName(String itemId) async {
    DocumentSnapshot itemDoc =
        await FirebaseFirestore.instance.collection('item_category').doc(itemId).get();
    if (itemDoc.exists) {
      return itemDoc['name'];
    }
    return 'Item Not Found';
  }
}




class CollaboratorContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Collaborator Page Content');
  }
}






/*class ProfileContent extends StatefulWidget {
  final String businessId;
  
  const ProfileContent ({super.key, required this.businessId});

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) => const MyApp()));
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}*/


class ProfileContent extends StatelessWidget {
  final String businessId;
  String email= "hello";
    TextEditingController emailAddressController = TextEditingController();
    TextEditingController abnController = TextEditingController();



  ProfileContent(this.businessId);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('businesses').doc(businessId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('Document does not exist.');
        } else {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          String email = data['email'];
          emailAddressController.text = email;
          String abn = data['abn'];
          String userName = data['firstName'];
          abnController.text = abn;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                ),
                SizedBox(height: 20),

                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Business',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailAddressController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Email Address'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: abnController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'ABN'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context) => const MyApp()));
                  },
                  child: const Text('Logout'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(businessId);
                    Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context) => BisChange(businessId: businessId)));
                  },
                  child: const Text('Change Profile Information'),
                ),
              ],
            ),
          );
        }
      }
    );
  }
}





// Function to add item category to Firestore
Future<String> _addItemCategoryToFirestore(String itemName) async {
  try {
    DocumentReference documentReference = await FirebaseFirestore.instance.collection('item_category').add({
      'name': itemName
    });
    print('New item category to Firestore');
    String itemId = documentReference.id;
    print('Item added to Firestore with ID: $itemId');
    return itemId;

  } catch (e) {
    print('Error adding item category to Firestore: $e');
    return '';
  }
}

// // Function to add an item to Firestore
// Future<void> _addNewItemToFirestore(String itemName) async {
//   try {
//     await FirebaseFirestore.instance.collection('items').add({
//       'name': itemName
//     });
//     print('New item added to Firestore');
//   } catch (e) {
//     print('Error adding item to Firestore: $e');
//   }
// }

Future<String?> _findItemIdByCategoryName(String itemName) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('item_category')
        .where('name', isEqualTo: itemName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Return the first document ID found
      return querySnapshot.docs.first.id;
    } else {
      return null; // Item not found
    }
  } catch (e) {
    print('Error finding item ID: $e');
    return null;
  }
}


// Function to add an item to Firestore
Future<void> _addItemToFirestore(String itemName, int itemPoints, String businessId, String itemId) async {
  try {
    await FirebaseFirestore.instance.collection('scannable_items_org').add({
      'name': itemName,
      'points': itemPoints,
      'businessId': businessId,
      'itemId': itemId
    });
    print('Item added to Firestore');
  } catch (e) {
    print('Error adding item to Firestore: $e');
  }
}

// Function to edit an item in Firestore
Future<void> _editItem(String itemId, String newName, int newPoints) async {
  try {
    await FirebaseFirestore.instance.collection('scannable_items_org').doc(itemId).update({
      'name': newName,
      'points': newPoints,
    });
    print('Item with ID $itemId edited successfully');
  } catch (e) {
    print('Error editing item with ID $itemId: $e');
  }
}

// Function to delete an item in Firestore
Future<void> _deleteItem(String itemId) async {
  try {
    await FirebaseFirestore.instance.collection('scannable_items_org').doc(itemId).delete();
    print('Item with ID $itemId deleted successfully');
  } catch (e) {
    print('Error deleting item with ID $itemId: $e');
    // Handle error accordingly
  }
}










