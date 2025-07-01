import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/animations/animated_route.dart';
import 'package:app_m0v4u/ui/home_screen/views/home_screen.dart';
import 'package:app_m0v4u/ui/mainScreen/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {

      Navigator.pushReplacement(
        context,
        AnimatedRoute.slideFromBottom(const MainScreen(), routeName: '/main'),
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Replace with your image asset
              height: 150.0,
              width: 150.0,
            ),
            const SizedBox(height: 20.0),
            const CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppStyles.secondaryColor),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Loading...",
              style: TextStyle(
                color: AppStyles.secondaryColor,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
