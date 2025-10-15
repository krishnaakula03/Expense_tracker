import 'package:flutter/material.dart';
import 'package:flutter_expense/App/views/provider/homeprovider.dart';

import 'package:flutter_expense/Auntentication/provider/authprovider.dart';
import 'package:flutter_expense/constants/router.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isloggedin = pref.getBool('isloggedin') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authprovider()),
        ChangeNotifierProvider(create: (_) => Homeprovider()),
      ],
      child: MyApp(isloggedin: isloggedin),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isloggedin;
  const MyApp({super.key, required this.isloggedin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        routerConfig: router(isloggedin));
  }
}
