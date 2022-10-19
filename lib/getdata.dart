import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
class GetDataPage extends StatefulWidget {
  const GetDataPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<GetDataPage> createState() => _GetDataPageState();
}

class _GetDataPageState extends State<GetDataPage> {
  List data =[];
  bool isLoading =true;

  void getData() async {

    try {
      var url = Uri.https('jsonplaceholder.typicode.com','/todos/');
      Response response = await get(url);
      setState(() {
        isLoading = false;
        data = jsonDecode(response.body);
      });
      // print(data);
    } on Exception catch (e) {
      print('$e on get');
    }
  }


  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

      return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: isLoading? Container(
          color: Colors.amber[100],
          child: const Center(
              child: Text(
                  "loading",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold
                  ))),
        ):
          ListView.builder(
          itemCount: data.length ,
          itemBuilder: (context,index){
            return Card(
              child: ListTile(
                onTap: (){
                  Navigator.pushNamed(context, '/detaildata',arguments: {
                    'id': data[index]['id'],
                    'title': data[index]['title']});
                },
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Text("${data[index]['id']}"),
                const SizedBox(height:20),
                Text(data[index]['title'])
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Getdata',
        child: const Icon(Icons.downloading),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}