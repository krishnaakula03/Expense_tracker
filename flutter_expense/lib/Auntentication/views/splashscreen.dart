import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense/App/views/bottomnavbar.dart';
import 'package:flutter_expense/constants/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key, required bool isloggedin});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, checkAndAuthenticate);
  }

  Future<void> checkAndAuthenticate() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isloggedin') ?? false;

    if (isLoggedIn) {
      bool authenticated = await authenticateUser();
      if (authenticated) {
        context.go('/home');
      } else {
        // Optionally close app or stay on splash
      }
    } else {
      context.go('/');
    }
  }

  Future<bool> authenticateUser() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (canCheckBiometrics && isDeviceSupported) {
        bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          options: const AuthenticationOptions(
            biometricOnly: false,
            stickyAuth: true,
          ),
        );
        return authenticated;
      }
      return false;
    } catch (e) {
      print("Biometric error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
