import 'package:flutter/material.dart';
import 'package:myflutterapp/home.dart';
//package import lib omitted
import 'package:myflutterapp/increment.dart';
//relative import
import 'getdata.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'home',),
        '/increment' : (context) => const IncrementPage(title: 'increment',),
        '/getdata' : (context) => const GetDataPage(title: 'getdata',)
      },
    );
  }
}


