import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app_april/utils/animation_constants.dart';
import 'package:note_app_april/view/notes_screen/notes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then(
      (value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NotesScreen(),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Lottie.asset(AnimationConstants.SPLASH_NOTE),
    ));
  }
}
