import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_expense/constants/apis.dart';
import 'package:flutter_expense/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';

class AuthHelper {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      bool isAvailable =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (!isAvailable) return false;

      return await auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: false,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }
}

class Authprovider extends ChangeNotifier {
  TextEditingController phoneno = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController DOB = TextEditingController();

  void signup(context) async {
    var url = Uri.parse(Apis.baseurl + Apis.signup);

    var response = await http.post(
      url,
      headers: {
        'content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'name': name.text,
        'email': email.text,
        'mobile_no': phoneno.text,
        'dob': DOB.text,
        'password': password.text,
      },
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print(res.toString());
      print(res['status']);
      if (res['status'] == true) {
        navigatorkey.currentContext?.go('/');
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res['message'])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.statusCode.toString())));
    }
  }

  login(context) async {
    var url = Uri.parse(Apis.baseurl + Apis.login);
    var response = await http.post(url, headers: {
      'content-type': 'application/x-www-form-urlencoded',
    }, body: {
      'identifier': phoneno.text,
      'password': password.text,
    });
    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      print(response.body.toString());
      final res = jsonDecode(response.body);
      if (res['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', res['user']['id'].toString());
        await prefs.setString('name', res['user']['name'].toString());
        await prefs.setString('email', res['user']['email'].toString());
        await prefs.setString('mobile_no', res['user']['mobile_no'].toString());
        await prefs.setString('dob', res['user']['dob'].toString());
        await prefs.setString('photo', res['user']['photo'].toString());
        await prefs.setBool('isloggedin', true);
        navigatorkey.currentContext?.go('/home');
        phoneno.clear();
        password.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? "enter correct details")));
      }
    }
  }

  String? Profilenumber;

  get isdarkmode => null;
  getSavedPhoneno() async {
    final prefs = await SharedPreferences.getInstance();
    Profilenumber = prefs.getString('phoneno');
  }
}
