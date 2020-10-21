import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'WelcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
//        duration: Duration(seconds: 1), vsync: this, upperBound: 100.0);
    controller.forward();
//    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation =
        ColorTween(begin: Colors.white, end: Colors.green).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
//      backgroundColor: Colors.red.withOpacity(controller.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Row(
                children: <Widget>[
                  Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/logo.png'),
                        height: 60,
                      )),
                  Center(
                    child: TypewriterAnimatedTextKit(
                      text: ['Flash Chat'],
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            Button('Log In', Colors.lightBlueAccent,
                () => Navigator.pushNamed(context, LoginScreen.id)),
            Button('Register', Colors.blueAccent,
                () => Navigator.pushNamed(context, RegistrationScreen.id)),
          ],
        ),
      ),
    );
  }
}
