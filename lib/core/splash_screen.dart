

import 'package:flutter/material.dart';
import 'package:link_dance/screens/home_screen.dart';
import 'package:splashscreen/splashscreen.dart';

class LinkDanceSplashScreen  extends StatefulWidget{
  @override
  State<LinkDanceSplashScreen> createState() =>LinkDanceSplashScreenState();
}

class LinkDanceSplashScreenState extends State<LinkDanceSplashScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return   Stack(
     children: <Widget>[
       SplashScreen(
         seconds: 5,
         gradientBackground: const LinearGradient(
           begin: Alignment.topRight,
           end: Alignment.bottomLeft,
           colors: [
             Color(0xffED213A),
             Color(0xff93291E)
           ],
         ),
         navigateAfterSeconds: HomeScreen(),
         loaderColor: Colors.transparent,
       ),
       Container(
         decoration: const BoxDecoration(
           image: DecorationImage(
             image: AssetImage("assets/images/logo/icon.png"),
             fit: BoxFit.none,
           ),
         ),
       ),
     ],
   );
  }

}

