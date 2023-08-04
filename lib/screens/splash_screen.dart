import 'package:flutter/material.dart';
import 'package:flutter_sqflite/constants/string_constants.dart';
import 'package:flutter_sqflite/screens/login_page.dart';
import 'package:flutter_sqflite/screens/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/image_constants.dart';
import '../helper/authenticationFunctions.dart';
import '../helper/prerences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;
  late final Animation<double> _animation;
  late AnimationController delayedcontroller;
  late final Animation<double> _delayedAnimation;
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    _delayedAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.8, 1, curve: Curves.fastOutSlowIn),
    );

    offset = Tween<Offset>(
            begin: const Offset(0.0, -5), end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut));

    wait();
  }

  Future wait() async {
    await Future.delayed(const Duration(seconds: 6));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // If we don't get any value back then it will be considered false;
    isLoggedIn = await Preferences.getBool(StringConstants.login, false);

    if (isLoggedIn) {
      String? email = await prefs.getString(StringConstants.email);

      List<String> person = await getPersonList(email!);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    //data: email.isEmpty ? "" : email,
                    dataList: person.length == 0 ? [] : person,
                  )));
    } else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _marvelAnimatedLogo(context),
        _animatedText(context),
        _footer()
      ],
    ));
  }

  Column _footer() {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                StringConstants.poweredBy,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              Image.asset(
                ImageConstant.successiveLogo,
                width: 35,
                height: 35,
                fit: BoxFit.scaleDown,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    StringConstants.successive,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3),
                  ),
                  Text(
                    StringConstants.technologies,
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ]);
  }

  Center _animatedText(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _delayedAnimation,
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: <Color>[
                    Colors.brown,
                    Colors.black,
                    Colors.brown,
                    Colors.black,
                  ],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  StringConstants.apps,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center _marvelAnimatedLogo(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: controller,
        child: ScaleTransition(
          scale: _animation,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Image.asset(ImageConstant.marvelLogo),
          ),
        ),
      ),
    );
  }
}
