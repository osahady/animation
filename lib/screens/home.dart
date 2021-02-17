import 'package:animation/widgets/cat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  //#region PROPERTIES
  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> boxAnimation;
  AnimationController boxController;
  //#endregion PROPERTIES

  @override
  void initState() {
    super.initState();
    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65)
        .animate(CurvedAnimation(curve: Curves.easeInOut, parent: boxController));
    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        boxController.reverse();
      else if (status == AnimationStatus.dismissed) boxController.forward();
    });
    boxController.forward();

    //animate cat
    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -35.0, end: -80.0)
        .animate(CurvedAnimation(parent: catController, curve: Curves.easeIn));
    catController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
            overflow: Overflow.visible,
          ),
        ),
        onTap: _onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          left: 0.0,
          right: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      width: 200.0,
      height: 200.0,
      color: Colors.brown,
    );
  }

  void _onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      boxController.stop();
    }
  }

  buildLeftFlap() {
    return Positioned(
      left: 5.0,
      top: 5.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(
            width: 125.0,
            height: 10.0,
            color: Colors.brown,
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: boxAnimation.value,
              child: child,
              alignment: Alignment.topLeft,
            );
          }),
    );
  }

  buildRightFlap() {
    return Positioned(
      right: 5.0,
      top: 5.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(
            width: 125.0,
            height: 10.0,
            color: Colors.brown,
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: -boxAnimation.value,
              child: child,
              alignment: Alignment.topRight,
            );
          }),
    );
  }
}
