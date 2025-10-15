import 'package:flutter_expense/App/views/add_trans.dart';
import 'package:flutter_expense/App/views/bottomnavbar.dart';
import 'package:flutter_expense/App/views/viewall.dart';
import 'package:flutter_expense/Auntentication/views/containers.dart';

import 'package:flutter_expense/Auntentication/views/forgot_pass.dart';
import 'package:flutter_expense/Auntentication/views/loginscreen.dart';
import 'package:flutter_expense/App/views/manage_balance.dart';

import 'package:flutter_expense/App/views/setting.dart';
import 'package:flutter_expense/Auntentication/views/signup.dart';
import 'package:flutter_expense/Auntentication/views/splashscreen.dart';
import 'package:flutter_expense/main.dart';
import 'package:go_router/go_router.dart';

GoRouter router(bool isloggedin) {
  return GoRouter(
    navigatorKey: navigatorkey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => Splashscreen(isloggedin: isloggedin),
      ),
      GoRoute(
          path: '/',
          builder: (context, state) => const Loginscreen(),
          routes: [
            GoRoute(
              path: '/signup',
              builder: (context, state) => const Signupscreen(),
            ),
            GoRoute(
              path: '/forgotpass',
              builder: (context, state) => const ForgotPass(),
            ),
          ]),
      GoRoute(
          path: '/home',
          builder: (context, state) => Bottomnavbar(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddTransactions(),
            ),
            GoRoute(
              path: 'manage',
              builder: (context, state) => const ManageBalance(),
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const Settingscreen(),
            ),
            GoRoute(
              path: 'viewall',
              builder: (context, state) => const Viewall(),
            ),
          ]),
    ],
  );
}
