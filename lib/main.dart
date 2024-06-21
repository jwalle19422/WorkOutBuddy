import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy/firebase_options.dart';
import 'package:workout_buddy/mainPages/home_page.dart';
import 'package:workout_buddy/utils/utils.dart';
import 'package:workout_buddy/verify_email_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await UserProfilePreferences.init();

  runApp( MyApp());
}
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {

   MyApp({Key? key}) : super(key: key);
  var utilsInstance = Utils();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: utilsInstance.messengerKey /*Utils.messengerKey*/,
      navigatorKey: navigatorKey ,
      title: 'Workout Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Over all color theme data
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.blueGrey,
        //Text theme data
        textTheme: GoogleFonts.tinosTextTheme(),

        //Button theme data
        elevatedButtonTheme:  ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
            //textStyle: TextStyle(fontFamily:),
            shape: const StadiumBorder(),
            minimumSize: const Size.fromHeight(45)),
        )
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //const MyHomePage();


  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if( snapshot.hasError){
            return Center(child: Text('Something Went Wrong... ${snapshot.error}'));
          }else if(snapshot.hasData){
            return const HomePage();
          }else{
            return const AuthPage();
          }
        },
      ),
    );
  }
}
