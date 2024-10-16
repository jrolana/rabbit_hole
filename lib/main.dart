import 'package:cmsc128_lab/pages/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:cmsc128_lab/pages/home.dart';
import 'package:cmsc128_lab/pages/statistics.dart';
import 'package:cmsc128_lab/utils/styles.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Prac Flutter',
        theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.lexendDecaTextTheme(),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: StyleColor.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.lexendDeca().fontFamily),
            )),
        home: BottomNavBar(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
