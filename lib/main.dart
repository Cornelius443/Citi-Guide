import 'package:city_guide/screens/wrapper.dart';
import 'package:city_guide/services/auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'screens/intro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(

    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),

    androidProvider: AndroidProvider.debug,

    appleProvider: AppleProvider.appAttest,
  );
  runApp(
      MaterialApp(

    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) =>  const Intro(),
      "/wrapper": (context) => const MyApp(),

    },
  ));
precacheImages();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (context, error) {

        return null; //  handling the error gracefully
      },
      child: MaterialApp(


        theme: ThemeData(
          cardTheme: CardTheme(
            color: Colors.blue[50]
          ),

          appBarTheme:  AppBarTheme(
              iconTheme: const IconThemeData(color: Colors.white),
            color: Colors.blue[900],
            titleTextStyle:  TextStyle(
              color: Colors.grey[200],
              fontSize: 25.0,
              fontFamily: "Pacifico"
            )
          ),



          primaryColor: Colors.black, // Set primary color to green
          scaffoldBackgroundColor: Colors.white, // Set scaffold background color to white

        ),
        debugShowCheckedModeBanner: false,
        home: const Wrapper(),
      ),
    );

  }

}

void precacheImages() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure WidgetsBinding is initialized
  Builder(
    builder: (BuildContext context) {
      precacheImage(const AssetImage('assets/images/asia.jpg'), context);
      precacheImage(const AssetImage('assets/images/city.jpeg'), context);
      precacheImage(const AssetImage('assets/images/asianCity.jpeg'), context);
      precacheImage(const AssetImage('assets/images/african.jpeg'), context);

      return Container();
    },
  );
}
