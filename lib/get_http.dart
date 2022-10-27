import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class GetHTTPPage extends StatefulWidget {
  const GetHTTPPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<GetHTTPPage> createState() => _GetHTTPPageState();
}

class _GetHTTPPageState extends State<GetHTTPPage> {
  List data =[];
  bool isLoading =true;
  String loadingString = 'loading';
  void getData() async {

    try {
      // var url = Uri.https('jsonplaceholder.typicode.com','/todos/');
      // var url = Uri.http('127.0.0.1:5551','/');
      // var url = Uri.http('localhost:5551','/');
      var url = Uri.https('localhost:5551','/');
      Response response = await get(url);
      setState(() {
        isLoading = false;
        data = jsonDecode(response.body);
      });
      // print(data);
    } on Exception catch (e) {
      print('$e on get');
      setState(() {
        loadingString = e.toString();
      });
    }

  }

  Future<SecurityContext> get globalContext async {
    final sslCert1 = await rootBundle.load('assets/cert.pem');
    final keystore = await rootBundle.load('assets/keystore.p12');
    // SecurityContext ctx = SecurityContext.defaultContext;

    SecurityContext ctx = SecurityContext(withTrustedRoots: false);
    ctx.setTrustedCertificatesBytes(sslCert1.buffer.asInt8List());
/*  String password = 'xxxxxx';
  ctx.useCertificateChainBytes(keystore.buffer.asUint8List(),password: password);
  ctx.usePrivateKeyBytes(keystore.buffer.asUint8List(),password: password);*/
    return ctx;
  }

  Future<void> getDatatHttpClient() async{
    bool _certificateCheck(truststore, String host, int port) {
      print("in _certificateCheck t: $truststore h: $host p : $port ");
      return false;
    }
    var client = HttpClient(context: await globalContext)
      ..badCertificateCallback = (X509Certificate cert, String host, int port){
        print("in bad certificate $cert $host $port");
        return true;
      };


    var uri = Uri.parse("https://localhost:5551");
    print(uri.host); // 10.0.0.1
    print(uri.port); // 5551
    print(uri.path); //

    var request = await client.getUrl(uri);
    var response = await request.close();


    if (response.statusCode == HttpStatus.ok) {
      var jsonString = await response.transform(utf8.decoder).join();
      var json = await jsonDecode(jsonString);
      setState(() {
        try{
          data = json;
          isLoading = false;
        } catch(e){
          loadingString = e.toString();
        }

      });

    } else {

      setState(() {
        loadingString = " status code is ${response.statusCode.toString()}";
      });

    }
  }



  @override
  void initState() {
    super.initState();
    // getData();
    getDatatHttpClient();
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
          child: Center(
              child: Text(
                  loadingString,
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