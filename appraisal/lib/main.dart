import 'package:appraisal/login_screen.dart';
import 'package:appraisal/repository/UserStorage.dart';
import 'package:appraisal/views/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Color(0xFF5e77ae),
        scaffoldBackgroundColor: Colors.grey.shade200,
        fontFamily: GoogleFonts.karla().fontFamily,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
            color: CupertinoColors.white,
            textTheme: TextTheme(
                headline6: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: GoogleFonts.karla().fontFamily,
                    fontWeight: FontWeight.bold)),
            iconTheme: IconThemeData(color: Colors.black)),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: token != null && authenticatedUser != null
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
