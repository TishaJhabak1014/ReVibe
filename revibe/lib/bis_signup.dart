import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart'; 
import 'dart:async'; 
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'login_page.dart'; 


class BisSignUp extends StatefulWidget {
  @override
  _BisSignUpState createState() => _BisSignUpState();
}

String hashPassword(String password) {
  // SHA-256 for hashing
  var bytes = utf8.encode(password);
  var hashedPassword = sha256.convert(bytes).toString();
  return hashedPassword;
}

// class _BisSignUpState extends State<BisSignUp> {
//   final _formKey = GlobalKey<FormState>();

//   TextEditingController businessNameController = TextEditingController();
//   TextEditingController abnController = TextEditingController();
//   TextEditingController emailAddressController = TextEditingController();
//   TextEditingController additionalEmailAddressController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController locationController = TextEditingController();
//   TextEditingController stateController = TextEditingController();
//   TextEditingController councilController = TextEditingController();
//   TextEditingController mapLocationController = TextEditingController();
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController contactPhoneController = TextEditingController();
//   TextEditingController positionController = TextEditingController();
//   TextEditingController websiteController = TextEditingController();
//   TextEditingController facebookPageController = TextEditingController();
//   TextEditingController instagramProfileController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();

//   String errorMessage = '';

//   bool isValidEmail(String email) {
//     RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
//     return emailRegex.hasMatch(email);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Business Sign Up'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),

//         child: Form(
//           key: _formKey,
//           // mainAxisAlignment: MainAxisAlignment.center,
//           child: Column(
//             // Add your business sign-up form fields here
//             // Business details
//               TextFormField(
//                 controller: businessNameController,
//                 decoration: InputDecoration(labelText: 'Business Name'),
//                 validator: (value) {
//                   if (value?.isEmpty ?? true) {
//                     return 'This field is required';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: abnController,
//                 decoration: InputDecoration(labelText: 'ABN (optional)'),
//                 validator: (value) {
//                   if (value?.isEmpty ?? true) {
//                     return 'This field is required';
//                   }
//                   return null;
//                 },
//               ),
//               TextField(
//                 controller: emailAddressController,
//                 decoration: InputDecoration(labelText: 'Email Address'),
//               ),
//               TextField(
//                 controller: additionalEmailAddressController,
//                 decoration:
//                     InputDecoration(labelText: 'Additional Email Address (optional)'),
//               ),
//               TextField(
//                 controller: phoneNumberController,
//                 decoration: InputDecoration(labelText: 'Displayed Phone Number'),
//               ),
//               TextField(
//                 controller: locationController,
//                 decoration: InputDecoration(labelText: 'Location'),
//               ),
//               TextField(
//                 controller: stateController,
//                 decoration: InputDecoration(labelText: 'Choose a State'),
//               ),
//               TextField(
//                 controller: councilController,
//                 decoration: InputDecoration(labelText: 'What Local Council Are You In?'),
//               ),
//               TextField(
//                 controller: mapLocationController,
//                 decoration: InputDecoration(labelText: 'Map Location'),
//               ),

//               // Contact details
//               TextField(
//                 controller: firstNameController,
//                 decoration: InputDecoration(labelText: 'First Name'),
//               ),
//               TextField(
//                 controller: lastNameController,
//                 decoration: InputDecoration(labelText: 'Last Name'),
//               ),
//               TextField(
//                 controller: contactPhoneController,
//                 decoration: InputDecoration(labelText: 'Contact Phone'),
//               ),
//               TextField(
//                 controller: positionController,
//                 decoration: InputDecoration(labelText: 'Position / Role'),
//               ),
//               TextField(
//                 controller: websiteController,
//                 decoration: InputDecoration(labelText: 'Website (optional)'),
//               ),
//               TextField(
//                 controller: facebookPageController,
//                 decoration: InputDecoration(labelText: 'Facebook Page (optional)'),
//               ),
//               TextField(
//                 controller: instagramProfileController,
//                 decoration: InputDecoration(labelText: 'Instagram Profile (optional)'),
//               ),

//               // Password
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               TextField(
//                 controller: confirmPasswordController,
//                 decoration: InputDecoration(labelText: 'Confirm Password'),
//                 obscureText: true,
//               ),

//               SizedBox(height: 16),

//             ElevatedButton(
//               onPressed: () async {
//                 if (_formKey.currentState?.validate() ?? false) {
//                       // Form is valid, proceed with the submission
//                       // Access the values using controller.text
//                       // For example:
//                       String businessName = businessNameController.text;
//                       String abn = abnController.text;  
//                       await _submitBusinessToFirebase(context, businessName, abn);

//                       print('Form is valid');
//                 }
//                 // Add your business sign-up logic here

                                              
//                 // ... (similarly for other fields)

//                 // Perform further actions, for example, send data to Firebase
//               },
//               child: const Text('Submit Business Sign Up'),
//             ),

//             if (errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   errorMessage,
//                   style: TextStyle(color: Colors.red),
//                 ),
//              ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _BisSignUpState extends State<BisSignUp> {
  
  final _formKey = GlobalKey<FormState>();

  TextEditingController businessNameController = TextEditingController();
  TextEditingController abnController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController additionalEmailAddressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController councilController = TextEditingController();
  TextEditingController mapLocationController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactPhoneController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController facebookPageController = TextEditingController();
  TextEditingController instagramProfileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String errorMessage = '';

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: businessNameController,
                decoration: InputDecoration(labelText: 'Business Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: abnController,
                decoration: InputDecoration(labelText: 'ABN (optional)'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              TextField(
                controller: mapLocationController,
                decoration: InputDecoration(labelText: 'Map Location'),
              ),
              TextFormField(
                controller: emailAddressController,
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),

              //  Contact details
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: contactPhoneController,
                decoration: InputDecoration(labelText: 'Contact Phone'),
              ),
              TextField(
                controller: positionController,
                decoration: InputDecoration(labelText: 'Position / Role'),
              ),
              TextField(
                controller: websiteController,
                decoration: InputDecoration(labelText: 'Website (optional)'),
              ),
              TextField(
                controller: facebookPageController,
                decoration: InputDecoration(labelText: 'Facebook Page (optional)'),
              ),
              TextField(
                controller: instagramProfileController,
                decoration: InputDecoration(labelText: 'Instagram Profile (optional)'),
              ),
              // Replace TextField with TextFormField for the rest of the fields
              // ...
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {

                  if (passwordController.text != confirmPasswordController.text) {
                      setState(() {
                      errorMessage = 'Passwords do not match';
                    });
                    return;
                  }

                  if (_formKey.currentState?.validate() ?? false) {
                    String businessName = businessNameController.text;
                    String abn = abnController.text;
                    String email = emailAddressController.text;
                    String password = passwordController.text;
                    // ... (similarly for other fields)
                    password = hashPassword(password);

                    await _submitBusinessToFirebase(context, businessName, abn, email, password);

                    
                  }
                },
                child: const Text('Submit Business Sign Up'),
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ... (submit function)
  // Example function to submit business data to Firebase
  Future<void> _submitBusinessToFirebase(
      BuildContext context, String businessName, String abn, String email, String password) async {
    // Your Firebase logic for business sign-up here
    // Note: Ensure you have initialized Firebase in your app before using these services
    // Example:
    final collection = FirebaseFirestore.instance.collection('businesses');
    try {
      await collection.doc().set(
        {
          'timestamp': FieldValue.serverTimestamp(),
          'firstName': businessName,
          'abn': abn,
          'email': email,
          'password': password
          // ... (similarly for other fields)
        },
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(userType: 2),
        ),
      );
    } catch (error) {
      // Display an error message on the page
      setState(() {
        errorMessage = 'Error submitting to Firebase: $error';
      });
    }
  }


}


  