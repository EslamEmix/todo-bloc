import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/splash/splash_bloc.dart';
import 'package:todo/bloc/todo/repo.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/ui/splash_screen.dart';
import './ui/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (BuildContext context) => SplashBloc(),
        ),
        BlocProvider<TodoBloc>(
          create: (BuildContext context) => TodoBloc(TodoRepo()),
        ),
      ],
      child: MaterialApp(
        routes: {
          HomeScreen.ROUTE_NAME: (ctx) => HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'ToDo App',
        home: SplashScreen(),
      ),
    );
  }
}
