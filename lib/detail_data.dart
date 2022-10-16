
import 'dart:convert';

import 'package:flutter/material.dart';

class DetailDataPage extends StatelessWidget {
  const DetailDataPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    /*
    casting to Map<String,Object> throws error that _internalLinkedHashMap p<String,dynamic>
    is not a subtype of type 'Map<String,Object> in type cast.
    in order to cast as Map<String,Object> use stackflow answer to
    serialize and deserialize internallinkedhashmap Map<String,Object> to Map<String,dynamic>
    final  args_passed =  ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final  args =  json.decode(json.encode(args_passed)) as Map<String, dynamic>;

    if not serialize and deserializ, cast arguments to Map or Map<String,dynamic>
 */
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    print("args type is ${args.runtimeType}");

    return Scaffold(
      backgroundColor: Colors.amber[100],
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${args['id']}'),
              Text('${args['title']}'),
            ],
          ),
        )
    );
  }
}
