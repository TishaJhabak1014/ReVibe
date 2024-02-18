import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:revibe/main.dart';

class DashboardPage extends StatefulWidget {
  final String userName;
  final String userID;

  const DashboardPage({required this.userName, required this.userID});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(userName: widget.userName, userID: widget.userID),
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
            const Text(
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
        title: const Text('Scan QR Code'),
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




// Navigation Bar Layout
class NavigationBar extends StatelessWidget {
  final String userName;
  final String userID;

  const NavigationBar({required this.userName, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Navigation(userName: userName, userID: userID);
  }
}

// Navigation State
class Navigation extends StatefulWidget {
  final String userName;
  final String userID;

  Navigation({Key? key, required this.userName, required this.userID}) : super(key: key);

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
            icon: Icon(Icons.recycling),
            label: 'Recycle',
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
        child: _buildPage(currentPageIndex, widget.userName, widget.userID),
      ),

    );
  }
}


// Function to build content based on the selected index
Widget _buildPage(int index, String userName, String userID) {
  switch (index) {
    case 0:
      return HomeContent(userName: userName, userID: userID);
    case 1:
      return RecycleContent(userName: userName, userID: userID); 
    case 2:
      return StatsContent(); 
    case 3:
      return ProfileContent(userName: userName, userID: userID); 
    default:
      return Container();
  }
}



class HomeContent extends StatefulWidget {
  final String userName;
  final String userID;

  const HomeContent({required this.userName, required this.userID});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
   
      ),
      body: const BuildBody()
        
    );
  }

  // Popular item format
  Widget buildIconContainer() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 200,
        width: 250,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.amber,
        ),
        child: const Icon(
          Icons.contacts,
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}

class RecycleContent extends StatelessWidget {
  final String userName;
  final String userID;

  RecycleContent({required this.userName, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycables'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
  
            const SizedBox(height: 16),
            // Display the list of items
            ItemList(userID: userID),
          ],
        ),
      ),
    );
  }
}

class StatsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        

          SizedBox(height: 1.0), 

          // Text widget
          Text(
            'Your Text Here',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileContent extends StatefulWidget {
  final String userID;
  final String userName;
  
  const ProfileContent({Key? key, required this.userID, required this.userName}) : super(key: key);

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  String email= "hello";
  TextEditingController emailAddressController = TextEditingController();

 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(widget.userID).get(),
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
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: Padding(
            padding: EdgeInsets.all(16.0),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                  ),
                  SizedBox(height: 20),

                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'user',
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (context) => const MyApp()));
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
              
            )
          );
        }
      }
    );
  }
}