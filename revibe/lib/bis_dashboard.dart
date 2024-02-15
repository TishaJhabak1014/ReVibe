import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'main.dart';

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
            label: 'Dashboard',
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
      return TransactionContent(); 
    case 3:
      return CollaboratorContent(); 
    case 4:
      return ProfileContent(businessId: businessID,); 
    default:
      return Container();
  }
}







class HomeContent extends StatefulWidget {
  final String businessId;
  
  const HomeContent ({super.key, required this.businessId});

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
              MaterialPageRoute(builder: (context) => QRScannerScreen()),
            );
          },
          child: const Text('Scan QR code'),
        ),
      ),
    );
  }
}


class QRScannerScreen extends StatefulWidget {
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
        builder: (context) => DisplayScannedDataScreen(scannedData: scannedData),
      ),
    ).then((_) {
      isDisplayScreenShown = false;
    });
  }
}

class DisplayScannedDataScreen extends StatelessWidget {
  final String scannedData;

  const DisplayScannedDataScreen({Key? key, required this.scannedData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the scanned data here
    final parsedData = _parseScannedData(scannedData);

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
            Text(
              parsedData,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _parseScannedData(String scannedData) {
    final parts = scannedData.split('|');
    return 'UserID: ${parts[0]}\nItemID: ${parts[1]}';
  }
}


















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


  // Function to show the dialog box for adding an item
  Future<void> _showAddItem(BuildContext context) async {
    String itemName = ''; 
    int itemPoints = 0;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(


          // title
          title: const Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Item Name'),
                onChanged: (value) {
                  itemName = value; 
                },
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
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addItemToFirestore(itemName, itemPoints, widget.businessId);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
  @override
  Widget build(BuildContext context) {
    return Text('Transaction Page Content');
  }
}

class CollaboratorContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Collaborator Page Content');
  }
}






class ProfileContent extends StatefulWidget {
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
}









// Function to add an item to Firestore
Future<void> _addItemToFirestore(String itemName, int itemPoints, String businessId) async {
  try {
    await FirebaseFirestore.instance.collection('scannable_items_org').add({
      'name': itemName,
      'points': itemPoints,
      'businessId': businessId,
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