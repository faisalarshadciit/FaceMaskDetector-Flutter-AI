import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'home_page.dart';

class MySplashScreen extends StatefulWidget {

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 10,
      navigateAfterSeconds: HomePage(),
      title: Text("Face Mask Detector App",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.black,
          ),
        textAlign: TextAlign.center,
      ),
      image: Image.asset('assets/splash.png'),
      backgroundColor: Colors.white,
      photoSize: 130,
      loaderColor: Colors.black,
      loadingText: Text(
        "From Coding Cafe",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
