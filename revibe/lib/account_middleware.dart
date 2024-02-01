import 'package:flutter/material.dart';
import 'package:revibe/fund_signup.dart';
import 'package:revibe/login_page.dart';
import 'signup_page.dart'; // Assuming SignUpPage is in the same directory
import 'bis_signup.dart';

class AccountMiddlewarePage extends StatefulWidget {
  final int actionType; // Change the type to String

  AccountMiddlewarePage({required this.actionType});

  @override
  _AccountMiddlewarePageState createState() => _AccountMiddlewarePageState();
}


class _AccountMiddlewarePageState extends State<AccountMiddlewarePage>{
  
  @override
  Widget build(BuildContext context) {
    int actionType = widget.actionType; 
    print(actionType); // Initialize userType in the build method

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Middleware'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to SignUpPage for normal user registration
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (actionType == 2) {
                        return SignUpPage(userType: 1);
                      } else {
                        return LoginPage(userType: 1);
                      }
                    },

                  ),
                );
              },
              child: Text('Procced as Normal User'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to SignUpPage for business registration
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (actionType == 2) {
                        return BisSignUp();
                      } else {
                        return LoginPage(userType: 2);
                      }
                    },
                  ),
                );
              },
              child: Text('Procced as Business'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to SignUpPage for fundraiser registration
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (actionType == 2) {
                        return FundraiserSignUp();
                      } else {
                        return LoginPage(userType: 3);
                      }
                    },
                  ),
                );
              },
              child: Text('Procced as Fundraiser'),
            ),


            
          ],
        ),
      ),
    );
  }
}
