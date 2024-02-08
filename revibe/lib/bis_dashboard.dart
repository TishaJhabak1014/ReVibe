import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Stats',
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
      return HomeContent();
    case 1:
      return TransactionContent(); 
    case 2:
      return CollaboratorContent(); 
    case 3:
      return ProfileContent(); 
    default:
      return Container();
  }
}



class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Home Page Content');
  }
}


class TransactionContent extends StatefulWidget {
  const TransactionContent({super.key});

  @override
  _TransactionContentState createState() => _TransactionContentState();
}


class _TransactionContentState extends State<TransactionContent> {
  // Initial point threshold value
  int _pointThreshold = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Content'),
      ),

      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('scannable_items_org').snapshots(),
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
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    var itemName = item['name']; // Replace 'name' with the field name in your Firestore document
                    return ListTile(
                      title: Text(itemName),
                      // Add other properties you want to display
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }




  // Edit points button
  Future<void> _editBusinessPointThresholdDialog(BuildContext context) async {
    return showDialog(
      context: context,

      builder: (BuildContext context) {
        return AlertDialog(

          // Title 
          title: const Text('Edit Point Threshold'),


          // Title
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'New Point Threshold',
            ),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: _pointThreshold.toString()), // Set initial value here
            onChanged: (String value) {
              setState(() {
                _pointThreshold = value.isEmpty ? 0 : int.tryParse(value) ?? _pointThreshold;
              });
            },
          ),


          // Actions
          actions: <Widget>[


            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),


            TextButton(
              onPressed: () {
                // Perform any action here with the updated threshold value
                // For example, you can save it to preferences or send it to the server.
                print('New Point Threshold: $_pointThreshold');
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),


          ],
        );
      },
    );
  }
}



class CollaboratorContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Collaborator Page Content');
  }
}


class ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Profile Page Content');
  }
}

