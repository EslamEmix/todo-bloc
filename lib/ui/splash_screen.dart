import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/splash/splash_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/model/todo_item.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    startTime();
  }

  startTime() {
    BlocProvider.of<SplashBloc>(context).add(StartTimeEvent());
    // context.bloc<SplashBloc>();
  }

  Future navigationPage() async {
    Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is EndTime) navigationPage();
        },
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Container(
                width: 100,
                height: 100,
              ),
            ),
            Center(child: Image.asset("assets/IMG_20180730_133805.gif")),
          ],
        ),
      ),
    );
  }
}
