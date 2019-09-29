import 'package:firebasestoragetest/HomePage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((_){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(),),);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                width: 200,
                height: 200,
                child:  Image(image: AssetImage('Ultimate_Communety_Logo.png'),),
              ),
            ),
            LinearProgressIndicator(backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen), )
          ],
        )
      )
    );
  }
}
