import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:revibe/main.dart';

class FundDashboard extends StatefulWidget {
  final String userID;

  const FundDashboard({required this.userID});

  @override
  _FundDashboardState createState() => _FundDashboardState();
}

class _FundDashboardState extends State<FundDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(userID: widget.userID),
    );
  }
}

class ItemList extends StatelessWidget {
  final String userID;

  ItemList({required this.userID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('fundraiser_post').snapshots(),
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
                  String postID = item.id;

                  
                },
                child: ListTile(
                  title: Text(
                    item['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  //subtitle: Text('Points: ${item['points']}'),
                ),
              ),
          ],
        );
      },
    );
  }
}




// Navigation Bar Layout
class NavigationBar extends StatelessWidget {
  final String userID;

  const NavigationBar({required this.userID});

  @override
  Widget build(BuildContext context) {
    return Navigation(userID: userID);
  }
}

// Navigation State
class Navigation extends StatefulWidget {
  final String userID;

  Navigation({Key? key, required this.userID}) : super(key: key);

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
            icon: Icon(Icons.post_add),
            label: 'Post',
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
        child: _buildPage(currentPageIndex, widget.userID),
      ),

    );
  }
}


// Function to build content based on the selected index
Widget _buildPage(int index, String userID) {
  switch (index) {
    case 0:
      return HomeContent(userID: userID);
    case 1:
      return PostContent(fundraiserId: userID); 
    case 2:
      return StatsContent(); 
    case 3:
      return ProfileContent(userID: userID,); 
    default:
      return Container();
  }
}


class HomeContent extends StatefulWidget {
  final String userID;

  const HomeContent({required this.userID});

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







class PostContent extends StatefulWidget {
  final String fundraiserId;
  
  const PostContent ({super.key, required this.fundraiserId});

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Content'),
      ),


      body: StreamBuilder<QuerySnapshot>(

        // check for items matching businessID
        stream: FirebaseFirestore.instance
            .collection('fundraiser_post')
            .where('fundraiserId', isEqualTo: widget.fundraiserId)
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
                  'Posts',
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
                child: const Text('Add Post'),
              ),




              // Item list
              items.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          var postTitle = item['title'];
                          var postContent = item['content'];

                          return InkWell(
                            onTap: () {
                              _showEditItem(context, item.id);
                            },
                            child: ListTile(
                              title: Text(
                                postTitle,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              //subtitle: Text('Points: $itemPoints'),
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
    String postTitle = ''; 
    String postContent = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(


          // title
          title: const Text('Add New Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Post Name'),
                onChanged: (value) {
                  postTitle = value; 
                },
              ),

              const SizedBox(height: 16),

              TextField(
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'Enter your content here...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                ),
                onChanged: (value) {
                  postContent = value;
                },
              )

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
                _addItemToFirestore(postTitle, postContent, widget.fundraiserId);
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
  void _showEditItem(BuildContext context, String postId) {
    FirebaseFirestore.instance.collection('fundraiser_post').doc(postId).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String postName = documentSnapshot['title'];
        String postContent = documentSnapshot['content'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Post Action'),
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
                          builder: (context) => EditItemPage(postId: postId, postName: postName, postContent: postContent),
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
                      _deleteItem(postId); 
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
  final String postId;
  final String postName;
  final String postContent;

  EditItemPage({required this.postId, required this.postName, required this.postContent});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _titleController;
  late TextEditingController _postController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.postName);
    _postController = TextEditingController(text: widget.postContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _postController.dispose();
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
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Post Name',
                ),
              ),
              const SizedBox(height: 20),


              SingleChildScrollView(
                child: TextFormField(
                  controller: _postController,
                  decoration: const InputDecoration(
                    labelText: 'Post Content',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  ),
                  maxLines: null, // Allow multiple lines for content
                ),
              ),

              const SizedBox(height: 20),



              ElevatedButton(
                onPressed: () {
                  // Handle saving changes here
                  String newTitle = _titleController.text;
                  String newContent = _postController.text;
                  _editItem(widget.postId, newTitle, newContent);
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
  
  const ProfileContent ({super.key, required this.userID});

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
Future<void> _addItemToFirestore(String postTitle, String postContent, String fundraiserId) async {
  try {
    await FirebaseFirestore.instance.collection('fundraiser_post').add({
      'title': postTitle,
      'content': postContent,
      'fundraiserId': fundraiserId,
    });
    print('Post added to Firestore');
  } catch (e) {
    print('Error adding item to Firestore: $e');
  }
}

// Function to edit an item in Firestore
Future<void> _editItem(String postId, String newTitle, String newContent) async {
  try {
    await FirebaseFirestore.instance.collection('fundraiser_post').doc(postId).update({
      'title': newTitle,
      'content': newContent,
    });
    print('Post with ID $postId edited successfully');
  } catch (e) {
    print('Error editing item with ID $postId: $e');
  }
}

// Function to delete an item in Firestore
Future<void> _deleteItem(String postId) async {
  try {
    await FirebaseFirestore.instance.collection('fundraiser_post').doc(postId).delete();
    print('Item with ID $postId deleted successfully');
  } catch (e) {
    print('Error deleting item with ID $postId: $e');
    // Handle error accordingly
  }
}