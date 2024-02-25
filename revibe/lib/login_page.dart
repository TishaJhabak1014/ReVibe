import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:revibe/account_middleware.dart';
import 'package:revibe/bis_dashboard.dart';
import 'package:revibe/fund_dashboard.dart';



class LoginPage extends StatefulWidget {
  final int userType;

  LoginPage({required this.userType});

  @override
  _LoginPageState createState() => _LoginPageState();
}


// Function to hash the password using SHA-256
String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var hashedPassword = sha256.convert(bytes).toString();
  return hashedPassword;
}

class _LoginPageState extends State<LoginPage>{
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int userType = widget.userType; 

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/logo.png',
                width: 60,
                height: 60,
              ),
            ),
            const Text(
              'ReVibe',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(221, 242, 232, 1),
      ),

      
      body: Container(
        color: const Color(0xFFF0F3EF),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Login',
                  style: GoogleFonts.workSans(
                    textStyle: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF107208),
                      height: 1, 
                    ),
                  ),
                ),
                const SizedBox(height: 75.0),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                // Log In button
                ElevatedButton(
                  onPressed: () {
                    // Add logic for handling login
                    String email = emailController.text;
                    String password = passwordController.text;

                    // Perform further actions, e.g., check in the database
                    _performLogin(context, userType, email, password);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return const Color(0xFF107208); 
                      }
                      return Colors.white;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white; 
                      }
                      return Colors.black;
                    }),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
                  ),
                  child: const Text('Log In'),
                ),

                const SizedBox(height: 16),

                // Log In button to redirect to a different page
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the login page when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountMiddlewarePage(actionType: 2)), // Assuming LoginPage is your login page
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return const Color(0xFF107208); 
                      }
                      return Colors.white;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white; 
                      }
                      return Colors.black;
                    }),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
                  ),
                  child: const Text('Not a member yet? Join Now'),
                ),
              ],
            ),
          ),
        ),
      ),

  
    
    );
  }

 
  void _performLogin(BuildContext context, int userType, String email, String password) async {
    try {
      String hashedPassword = hashPassword(password);

      final collection;

      if(userType == 1){
        collection = FirebaseFirestore.instance.collection('users');
      }else if(userType == 2){
        collection = FirebaseFirestore.instance.collection('businesses');
      }else{
        collection = FirebaseFirestore.instance.collection('fundraisers');
      }
      
      var querySnapshot = await collection.where('email', isEqualTo: email).where('password', isEqualTo: hashedPassword).get();

      if (querySnapshot.docs.isNotEmpty) {


      if(userType == 1){
        Navigator.pushNamed(
          context,
          '/dashboard',
          arguments: {'userName': querySnapshot.docs.first['firstname'], 'userID': querySnapshot.docs.first.id
          }, 
        );
      }else if(userType == 2){
        String businessId = querySnapshot.docs.first.id;
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BisDashboard(businessId: businessId),
          ),
        );
      }else if(userType == 3){
        String userID = querySnapshot.docs.first.id;
        String userName = querySnapshot.docs.first['firstname'];
        print(userName);
        print(querySnapshot.docs.first.data());


        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FundDashboard(userID: userID, userName: userName,),
          ),
        );
      }
      
      
      
      else{
        Navigator.pushNamed(
          context,
          '/dashboard',
          arguments: {'userName': querySnapshot.docs.first['firstname'],
          }, 
        );
      }

      } else {
     
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
    
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    
  }
  }
}




