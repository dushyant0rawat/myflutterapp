import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class GetSSLPinningPage extends StatefulWidget {
  const GetSSLPinningPage({super.key, required this.title});

  final String title;

  @override
  State<GetSSLPinningPage> createState() => _GetSSLPinningPageState();
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    print("inside overrides httpcreate client");
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port){
      print("in bad certificate $cert $host $port");
      return true;
      };
  }
}

class _PiningSslData {
  String serverURL = "https://localhost:5551";
  Map<String, String> headerHttp = {};
  String allowedSHAFingerprint = "77F 40 DA 1F 12 11 5B C4 93 06 0D 04 DD 22 90 6F "
  "FD AE 78 9D";
  int timeout = 60;
  SHA sha = SHA.SHA1;
}
Future<SecurityContext> get globalContext async {
  final sslCert1 = await rootBundle.load('assets/cert.pem');
  final keystore = await rootBundle.load('assets/keystore.p12');
  // SecurityContext ctx = SecurityContext.defaultContext;

  SecurityContext ctx = SecurityContext(withTrustedRoots: false);
  ctx.setTrustedCertificatesBytes(sslCert1.buffer.asInt8List());
/*  String password = 'xxxxx';
  ctx.useCertificateChainBytes(keystore.buffer.asUint8List(),password: password);
  ctx.usePrivateKeyBytes(keystore.buffer.asUint8List(),password: password);*/
  return ctx;
}
Future<void> getConnection() async{

  String result;


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
      var json = await response.transform(utf8.decoder).join();
      print("json : $json");
      print(response.certificate);

    } else {

      throw Exception('Failed to load localhost');

    }
  }



class _GetSSLPinningPageState extends State<GetSSLPinningPage> {

  final _PiningSslData _data = _PiningSslData();
  late BuildContext scaffoldContext;
  // Platform messages are asynchronous, so we initialize in an async method.
  check(String url, String fingerprint, SHA sha, Map<String, String> headerHttp,
      int timeout) async {
    List<String> allowedShA1FingerprintList = [];
    allowedShA1FingerprintList.add(fingerprint);

    try {
      // Platform messages may fail, so we use a try/catch PlatformException.
      String checkMsg = await HttpCertificatePinning.check(
          serverURL: url,
          headerHttp: headerHttp,
          sha: sha,
          allowedSHAFingerprints: allowedShA1FingerprintList,
          timeout: timeout);

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(checkMsg),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  void initState() {
    super.initState();
    print("before inside initstate in sslpinning");
    // HttpOverrides.global = MyHttpOverrides();
    check(_data.serverURL, _data.allowedSHAFingerprint, _data.sha,
        _data.headerHttp, _data.timeout);
    getConnection();
    print("after inside initstate in sslpinning");
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: const Center(
          child: Text(
              "ssl pinning",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Getdata',
        child: const Icon(Icons.downloading),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}