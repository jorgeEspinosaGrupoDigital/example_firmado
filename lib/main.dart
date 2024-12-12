import 'dart:io';
import 'dart:typed_data';

import 'package:example_firmado/pdf_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gse_bemyself_protobuf/gse_bemyself_protobuf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pki_pdf_signer/page_widget/document_pki.dart';
import 'package:pki_pdf_signer/page_widget/page_signer.dart';
import 'package:pki_pdf_signer/pki_pdf_signer.dart';
import 'package:pki_pdf_signer/styles_main_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  String? _signatures;

  void myCallback(BuildContext context, InfoSign info)  async {
    Navigator.popUntil(context, (route) => route.isFirst);
    const String _token = "eyJhbGciOiJSUzI1NiJ9.eyJ1c2VybmFtZSI6Im1vYmlsZV9nc2VAYmVteXNlbGYuY29tIiwicGFzc3dvcmQiOiJQcnVlYmFzMTIzQCIsImVtYWlsIjoibW9iaWxlX2dzZUBiZW15c2VsZi5jb20iLCJndWlkIjoiY2VkNDM3ODctODlhZi00NjRkLTk4ZWQtYzE1ZTBkYjM0MzZiMTcxMjU4NDY5NDg5NTg5NSIsInBob25lIjoiMzExMTExMTExMSIsImZ1bGxOYW1lIjoiQmVNeXNlbGYiLCJPVFAiOiI3NTM3MDMiLCJjaXRpemVuU2VyaWFsSUQiOiJiNzQ5ZGIwYi1jNjVhLTQ0ZDktYjQ1NC1kMDlkMDgwMmMyNDAiLCJpYXQiOjE3MjQ4NTA3NDAsImlzcyI6Imh0dHBzOi8vcWEtYi5nc2UuY29tLmNvIn0.U4v4sajD1zLHZ24aXf7KDe5ZOzQkLRMoXMBB9RqDIgY0pOqwWklEp5ciNsEnHc-IwO6xvMNnfKTDTgng6GmQw0meKebAPtl6wAD40jBfpEM-vfv5QN-udTRFZIMdbq1_KF-vi47GCYNtzNIacC8bT2PAnRDr1ru-ljK1OKZkCK9Z5oY5hljDENwmaKjc4H_w3qr5eZdfFSTsSLYxMcixxlnU1AWg6h2ablfKdxdlvKmiRE4rI0ts1ftMHPEePWh_TfQIbhWFrMFrUTUTPUNvy4Gnr8ZIE_SGBCmfAWPlKsNKTkPO1s8atumTxlKIy25SZzd2_1Y2WYi4fLOullc6-Q";
    int pagina = info.page;
    String user = "MS21457";
    String pass = "8nTQFFpRQ2U=";
    bool qa = true;
    double x = info.relativeX;
    double y = info.relativeY;
    double w = info.relativeW;
    double h = info.relativeH;
    Uint8List docData = info.data;
    final resp = await SignerProtobuf.digitalSign(
        x: x,
        y: y,
        width: w,
        height: h,
        pagina: pagina,
        user: user,
        password: pass,
        docData: docData,
        url: "https://qacore-mys.bemyself.com/user/v1/service/signDocument",
        token: _token,
        tenant: "bmscol",
        tenantLanguage: "ES",
        clientSerialID: "b749db0b-c65a-44d9-b454-d09d0802c240",
        qa: qa,
        bordeFirma: true,
        docSize: info.docSize
    );
    resp.fold(
            (map) => print("status: ${map.statusCode}, message: ${map.message}")
        ,
            (map) async {
          final path = (await getApplicationDocumentsDirectory()).path;
          final file = File("$path/result.pdf");
          file.writeAsBytesSync(map.data);
          print("Escribio!!!");
          print(map.signatures);
          _signatures = map.signatures;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("signatures", _signatures ?? "[]");
        }
    );

  }




  void _quemado() async {
    final path = "${(await getApplicationDocumentsDirectory()).path}/result.pdf";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? signatures = await prefs.getString("signatures");
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => PdfView(path: path, showButton: false, signatures: signatures, callback: myCallback,)
        )
    );
  }

  void _incrementCounter() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['pdf'], type: FileType.custom);

    if (result != null) {
      final path = result.files.single.path!;
      final f = File(path);
      final data = f.readAsBytesSync();
      print('aja');
      //Navigator.push(context, MaterialPageRoute(builder: (ctx) => SinglePageSigner(data, 2)));
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => PdfView(path: path, showButton: true, callback: myCallback,)
          )
      );
    } else {
      // User canceled the picker
    }
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: ButtonBar(
        children: [
          FloatingActionButton(
          onPressed:_incrementCounter,
            tooltip: 'Increment',
          child: const Icon(Icons.file_open),
      ),
          FloatingActionButton(
            onPressed: _quemado,
            tooltip: 'Increment',
            child: const Icon(Icons.restart_alt),
          ),
        ]
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
