import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import './Home.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/AnimationSplash.json'),
      splashIconSize: 500,
      backgroundColor: Color.fromARGB(255, 247, 249, 251),
      nextScreen: HomePage(),
      pageTransitionType: PageTransitionType.fade,
    );
  }
}