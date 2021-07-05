import 'dart:developer';

import 'package:appentus_assessment/db/db_helper.dart';
import 'package:appentus_assessment/screen/home_screen.dart';
import 'package:appentus_assessment/screen/login_screen.dart';
import 'package:appentus_assessment/util/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.linear);
    _animation!.addStatusListener(
      (status) async {
        if (status == AnimationStatus.completed) {
          _controller!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller!.forward();
        }
      },
    );
    _controller!.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: DbHelper().initDb(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                return Center(
                  child: CircularProgressIndicator(),
                );

              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );

              case ConnectionState.done:
                _isLoggedIn = DbHelper().getUserBox()!.containsKey(Constant.isLoggedIn);
                log(_isLoggedIn.toString());
                Future.delayed(Duration(seconds: 3), () {
                  _gotoNextScreen();
                });
                return FadeTransition(
                  opacity: _animation!,
                  child: Center(
                    child: Text(
                      'Assessment',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                );

              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }

  _gotoNextScreen() {
    if (_isLoggedIn!) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
