import 'package:flutter/material.dart';
import 'package:revibe/account_middleware.dart';
import 'signup_page.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
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
        primarySwatch: Colors.green,
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
          final String userID = args?['userID'] ?? '';
          // Pass the argument to the DashboardPage
          return DashboardPage(userName: userName, userID: userID);
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
    double screenWidth = MediaQuery.of(context).size.width;

    bool isDesktop(BuildContext) => 
      screenWidth >= 600;

    bool isMobile(BuildContext) => 
      screenWidth < 600;
    
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


              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFDDF2E8),


          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountMiddlewarePage(actionType: 1),
                  ),
                );
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),



        body:  
        const BuildBody()
       
    );
  }
}




class BuildBody extends StatelessWidget {
  const BuildBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: MediaQuery.of(context).orientation == Orientation.portrait
          ? /* portrait */
          Container(
              color: const Color.fromARGB(255, 230, 223, 204),
              child: ListView(
                children: const [
                  Banner(),
                  DataBannerV(),
                  InfoBannerV(),
                  LoginBannerV(),
                  Footer(),
                ],
              ),
            )
          : /* landscape */
          Container(
              color: const Color.fromARGB(255, 230, 223, 204),
              child: ListView(
                children: const [
                  Banner(),
                  SizedBox(height: 100.0),
                  DataBannerH(),
                  InfoBannerH(),
                  LoginBannerH(),
                  Footer(),
                ],
              ),
            ),
    );
  }
}













class Banner extends StatelessWidget {
  const Banner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.5, 
      child: FittedBox(
        fit: BoxFit.cover,
        child: Image.asset("assets/welcome.png"),
      ),
    );
  }

}

class DataBannerV extends StatelessWidget {
  const DataBannerV({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 600,
        //color: const Color.fromARGB(255, 211, 232, 183), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/recycle.png',
                width: 350,
                height: 350, 
              ),
            ),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    '76 million tonnes of waste are produced annually in Australia',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF107208),
                        height: 1, 
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    'Be part of the solution to save our wonderful environment',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        height: 1, 
                      ),
                    ),
                  ),
                ),
              ],
            ),     
          ],
        ),
      ),
    );
  }
}

class DataBannerH extends StatelessWidget {
  const DataBannerH({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 500,
        //color: const Color.fromARGB(255, 211, 232, 183), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/recycle.png',
                width: MediaQuery.of(context).size.width * 0.4,
                height: 350, 
              ),
            ),

            const SizedBox(width: 25.0),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    '76 million tonnes of\nwaste are produced\nannually in Australia',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF107208),
                        height: 1, 
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    'Be part of the solution to \nsave our wonderful environment',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        height: 1, 
                      ),
                    ),
                  ),
                ),
              ],
            ),    
          ],
        ),
      ),
    );
  }
}

class InfoBannerV extends StatelessWidget {
  const InfoBannerV({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 800,
        color: const Color.fromARGB(255, 209, 224, 181), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/bin.png',
                width: 300,
                height: 300, 
              ),
            ),



            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
    
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    'Why ReVibe?',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF107208),
                        height: 1, 
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    'Our point collection system empowers users to collect recyclables andreceive rewards for a simple action',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        height: 1, 
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25), 

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green), 
                      const SizedBox(width: 10), 
                      Flexible( 
                        child: Text(
                          'Recyclable items are redeemed through partnering stores',
                          style: GoogleFonts.workSans(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              height: 1, 
                            ),
                          ),
                          overflow: TextOverflow.fade, 
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green), 
                      const SizedBox(width: 10), 
                      Flexible( 
                        child: Text(
                          'Simply recycle to earn special offers',
                          style: GoogleFonts.workSans(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              height: 1, 
                            ),
                          ),
                          overflow: TextOverflow.fade, 
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green), 
                      const SizedBox(width: 10), 
                      Flexible( 
                        child: Text(
                          'Unlock the convenience of recycling and redeeming offers right at your fingertips',
                          style: GoogleFonts.workSans(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              height: 1, 
                            ),
                          ),
                          overflow: TextOverflow.fade, 
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoBannerH extends StatelessWidget {
  const InfoBannerH({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 500,
        color: const Color.fromARGB(255, 209, 224, 181), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [



            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
    
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    'Why ReVibe?',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF107208),
                        height: 1, 
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    'Our point collection system empowers users to collect\nrecyclables andreceive rewards for a simple action',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        height: 1, 
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25), 

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Row(
                    children: [
  
                      const Icon(Icons.check_circle, color: Colors.green), 
                      const SizedBox(width: 10), 
                      Text(
                        'Recyclable items are redeemed through partnering \nstores',
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            height: 1, 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Row(
                    children: [
  
                      const Icon(Icons.check_circle, color: Colors.green), 
                      const SizedBox(width: 10), 
                      Text(
                        'Simply recycle to earn special offers                     ',
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            height: 1, 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Row(
                    children: [
  
                      const Icon(Icons.check_circle, color: Colors.green), 
                      const SizedBox(width: 10), 
                      Text(
                        'Unlock the convenience of recycling and redeeming\noffers right at your fingertips',
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            height: 1, 
                          ),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),

            const SizedBox(width: 25.0),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/bin.png',
                width: MediaQuery.of(context).size.width * 0.25,
                height: 300, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBannerV extends StatelessWidget {
  const LoginBannerV({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 1000,
        color: const Color.fromARGB(255, 209, 224, 181),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                color: const Color(0xFFDDF2E8), 
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 10.0),
                      child: Text(
                        'Welcome ReVibers',
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF107208),
                            height: 1, 
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 50.0),
                      child: Text(
                        "Let's join forces and make a collective effort to recycle, aiming to create a positive impact on the world starting from today!",
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            height: 1, 
                          ),
                        ),
                      ),
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
                        minimumSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
                      ),
                      child: const Text('Log in'),
                    ),

                  ],
                )
              ),
            ),
            

            Expanded(
              child: Container(
                height: double.infinity,
                color: const Color(0xFFF0F3EF), 
                child: Column(
                  children: [


                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 10.0),
                      child: Text(
                        'Not a Member?',
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF107208),
                            height: 1, 
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
                      child: Text(
                        "Join our community to save the environment. Embrace sustainability, reduce waste, and advocate for a greener future. Together, let's make a lasting impact for a healthier planet",
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            height: 1, 
                          ),
                        ),
                      ),
                    ),


                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountMiddlewarePage(actionType: 2),
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
                        minimumSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBannerH extends StatelessWidget {
  const LoginBannerH({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 500,
        color: const Color.fromARGB(255, 209, 224, 181),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                color: const Color(0xFFDDF2E8), 
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 10.0),
                      child: Text(
                        'Welcome ReVibers',
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF107208),
                            height: 1, 
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 50.0),
                      child: Text(
                        "Let's join forces and make a collective effort to recycle, aiming to create a positive impact on the world starting from today!",
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            height: 1, 
                          ),
                        ),
                      ),
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
                        minimumSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
                      ),
                      child: const Text('Log in'),
                    ),

                  ],
                )
              ),
            ),
            

            Expanded(
              child: Container(
                height: double.infinity,
                color: const Color(0xFFF0F3EF), 
                child: Column(
                  children: [


                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 10.0),
                      child: Text(
                        'Not a Member?',
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF107208),
                            height: 1, 
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
                      child: Text(
                        "Join our community to save the environment. Embrace sustainability, reduce waste, and advocate for a greener future. Together, let's make a lasting impact for a healthier planet",
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            height: 1, 
                          ),
                        ),
                      ),
                    ),


                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountMiddlewarePage(actionType: 2),
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
                        minimumSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 212, 211, 211), 
      padding: const EdgeInsets.all(16.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '© 2024 ReVibe All Rights Reserved',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black
            ),
          )
        ],
      ),
    );
  }
}