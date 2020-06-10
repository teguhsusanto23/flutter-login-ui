import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String username,password;
  final _key = new GlobalKey<FormState>();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      print(username);
      login(username,password);
    }
  }
  _showMaterialDialog(String content,Color warna) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Message"),
          content: new Text(content),
          backgroundColor: warna,
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
  void _showModalSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        context: context,
        builder: (builder) {
          return Scaffold(
            body: Form(
              key: _key,
              child: new SingleChildScrollView(
                padding: EdgeInsets.all(5.0),
                child: Column(
                children: <Widget>[
                  SizedBox(width: 10,height: 30,),
                  TextFormField(
                    validator: (e) {
                      print(e.toString());
                      if (e.isEmpty) {
                        return "Please insert phone number";
                      }
                    },
                    onSaved: (e) => username = e,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.black12,
                      hintText: "62",
                    ),
                  ),
                  SizedBox(width: 10,height: 10,),
                  TextFormField(
                      obscureText:true,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please insert password";
                      }
                    },
                    onSaved: (e) => password = e,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.black12,
                      hintText: "password",
                    ),
                  ),
                  SizedBox(width: 10,height: 30,),
                  Container(
                    height: 50.0,
                    child: GestureDetector(
                      onTap: () { check(); },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.cyan,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,height: 20,),
                  InkWell(
                    onTap: () {
                    },
                    child: Text(
                      "Lupa Password",
                      textAlign: TextAlign.center,
                    )),
                  SizedBox(width: 10,height: 20,),
                  InkWell(
                      onTap: () {
                      },
                      child: Text(
                        "Belum punya account? Daftar disini",
                        textAlign: TextAlign.center,
                      )),
                ],
              )),
            ),
          );
        });
  }
  void login(String phone,password) async {
    print(phone);
    Map<String, dynamic> inputMap = {
      'phone': phone,
      'password': password
    };
    try {
      final response = await http.post('https://cerita.lumira.live/api/courier/login',body: inputMap);
      print("hasil ${ response.body }");
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showMaterialDialog("Welcome ${ data['name'] }",Colors.green);
        print(data);
      } else {
        print('Request failed with status: ${response.statusCode}.');
        _showMaterialDialog(data['invalid'],Colors.red);
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text('Welcome')),
            backgroundColor: Colors.blueAccent,
            body: Center(

                child: Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/login.png"),
                            fit: BoxFit.contain)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //BAGIAN INI NORMAL, HANYA MENAMPILKAN TEXT DENGAN STYLE MASING-MASING
                        Text(
                          "Clean Home",
                          style: TextStyle(
                              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Clean Life",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                                "Book Cleaner at the comfort of you home",
                                style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                            ),
                        ),
                        const SizedBox(height: 400),
                        FlatButton(
                          onPressed: _showModalSheet,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("Get Started"),
                        ),
                      ],
                    ),
                )
            )
        )
    );

  }
}

