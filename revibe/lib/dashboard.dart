import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DashboardPage extends StatelessWidget {
  final String userName;
  final String userID;

  DashboardPage({required this.userName, required this.userID});

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      bottomNavigationBar: NavigationBar(userName: userName, userID: userID),
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
      return ProfileContent(); 
    default:
      return Container();
  }
}

// Widgets for each navigation tab
class HomeContent extends StatelessWidget {
  final String userName;
  final String userID;

  HomeContent({required this.userName, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: 
      
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            // Welcome text
            Text(
              'Welcome, $userName!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 50.0),

            // Image
            SizedBox(
              height: 300,
              width: 300,
              child: FittedBox(
                fit: BoxFit.cover, 
                child: Image.asset("assets/recycle1.png"),
              ),
            ),

            // Spacer
            const SizedBox(height: 75.0),


            // Text widget - Popular
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: 
              
              Text(
                'Popular',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),


            // Popular items
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              child: Container(
                padding: const EdgeInsets.all(25.0), 
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                 
                ),

                child: SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildIconContainer(),
                      buildIconContainer(),
                      buildIconContainer(),
                      buildIconContainer(),
                      buildIconContainer(),
                    ],
                  ),
                ),
              ),
            ),
  

            const Padding(
              padding: EdgeInsets.all(20.0),
              child: 
              
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quam elementum pulvinar etiam non quam lacus. Enim nec dui nunc mattis. Amet nisl purus in mollis nunc. Et ultrices neque ornare aenean. Facilisi cras fermentum odio eu feugiat. Elementum tempus egestas sed sed. Tortor at risus viverra adipiscing at in tellus integer. Vulputate eu scelerisque felis imperdiet proin fermentum leo vel orci. Vitae congue eu consequat ac felis donec et odio. Bibendum at varius vel pharetra vel turpis nunc. Est lorem ipsum dolor sit amet consectetur adipiscing. Interdum posuere lorem ipsum dolor sit amet consectetur adipiscing. Viverra vitae congue eu consequat ac felis donec et. Nisl condimentum id venenatis a condimentum. Aliquam purus sit amet luctus venenatis lectus. Pulvinar etiam non quam lacus suspendisse faucibus interdum posuere. Ac placerat vestibulum lectus mauris ultrices. Curabitur gravida arcu ac tortor dignissim. Lacinia quis vel eros donec ac odio tempor orci dapibus. Rhoncus urna neque viverra justo nec ultrices dui. In hac habitasse platea dictumst quisque sagittis purus sit amet. Pellentesque dignissim enim sit amet venenatis urna cursus. Arcu risus quis varius quam quisque id diam vel. Eget duis at tellus at. Molestie at elementum eu facilisis sed. Arcu vitae elementum curabitur vitae nunc sed velit dignissim sodales. Ornare quam viverra orci sagittis eu volutpat. Pharetra et ultrices neque ornare aenean. Venenatis lectus magna fringilla urna porttitor. Ut porttitor leo a diam sollicitudin tempor. Aliquam eleifend mi in nulla posuere sollicitudin aliquam ultrices. Tellus elementum sagittis vitae et leo duis ut.',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
        color: Colors.white, size: 100.0,
      ),
    ),
  );
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






class ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Profile Page Content');
  }
}
