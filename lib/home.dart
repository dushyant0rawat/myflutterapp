import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context,'/increment');
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.amber[900])
        ),
        child: const Text('go to increment')),
        )
      );
  }
}