import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revibe/fund_signup.dart';
import 'package:revibe/login_page.dart';
import 'signup_page.dart';
import 'bis_signup.dart';

class AccountMiddlewarePage extends StatefulWidget {
  final int actionType; 

  AccountMiddlewarePage({required this.actionType});

  @override
  _AccountMiddlewarePageState createState() => _AccountMiddlewarePageState();
}



class _AccountMiddlewarePageState extends State<AccountMiddlewarePage> {
  @override
  @override
Widget build(BuildContext context) {
  int actionType = widget.actionType; 

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select Account Type',
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
            ElevatedButton(
              onPressed: () {
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
              child: const Text('Normal User'),
            ),
            const SizedBox(height: 25.0),
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
              child: const Text('Business User'),
            ),
            const SizedBox(height: 25.0),
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
              child: const Text('Fundraiser User'),
            ),
          ],
        ),
      ),
    ),
  );
}
}


