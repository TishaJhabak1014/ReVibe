import 'package:flutter/material.dart';
import 'package:revibe/account_middleware.dart';
import 'signup_page.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dashboard.dart';
import 'login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReVibe',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'ReVibe'),
      routes: {
        '/login': (context) => LoginPage(userType: 1),
        '/dashboard': (context) {
          final Map<String, dynamic>? args =
              ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          // Extract the required argument, for example, the user's name
          final String userName = args?['userName'] ?? '';

          // Pass the argument to the DashboardPage
          return DashboardPage(userName: userName);
        },

      },

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to ReVibe!',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountMiddlewarePage(actionType: 1),
                  ),
                );
              },
              child: const Text('Log in'),
            ),

            TextButton(
              onPressed: () {
                // Navigate to the login page when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountMiddlewarePage(actionType: 2)), // Assuming LoginPage is your login page
                );
              },
              child: Text('Not a member yet? Join Now'),
            ),
          ],
        ),
      ),
    );
  }
}
