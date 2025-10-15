import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense/App/views/provider/homeprovider.dart';
import 'package:flutter_expense/Auntentication/views/aboutapp.dart';
import 'package:flutter_expense/App/views/profile.dart';
import 'package:flutter_expense/Auntentication/views/privacypolicy.dart';
import 'package:flutter_expense/constants/colors.dart';
import 'package:flutter_expense/constants/images.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settingscreen extends StatelessWidget {
  const Settingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Homeprovider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor:
            provider.isdarkmode ? Appcolors.darkcolor : Appcolors.white,
        appBar: AppBar(
          backgroundColor:
              provider.isdarkmode ? Appcolors.darkcolor : Appcolors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.chevron_left,
                color: provider.isdarkmode
                    ? Appcolors.lightcolor
                    : Appcolors.black,
                size: 38,
              )),
          title: Text(
            "Settings",
            style: TextStyle(
              color:
                  provider.isdarkmode ? Appcolors.lightcolor : Appcolors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SlideInRight(
                child: settingwidget(
                    icon: Icons.person,
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()));
                    },
                    text: "My Profile"),
              ),
              const SizedBox(
                height: 20,
              ),
              SlideInRight(
                child: settingwidget(
                  icon: Icons.privacy_tip_outlined,
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Privacypolicy()));
                  },
                  text: "Privacy Policy",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SlideInRight(
                child: settingwidget(
                  isicon: false,
                  image: Appimages.aboutapp,
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Aboutapp()));
                  },
                  text: "About App",
                ),
              ),
              const SizedBox(height: 20),
              SlideInRight(
                child: Row(
                  children: [
                    Icon(
                      Icons.dark_mode,
                      size: 30,
                      color: provider.isdarkmode
                          ? Appcolors.lightcolor
                          : Appcolors.black,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Dark Mode",
                      style: TextStyle(
                        color: provider.isdarkmode
                            ? Appcolors.lightcolor
                            : Appcolors.black,
                        fontSize: 22,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: provider.isdarkmode,
                      onChanged: (_) => provider.toggledarkmode(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            // backgroundColor: Colors.black,
                            title: const Text('Confirm Logout ?'),
                            content: const Text('Are you sure want to logout'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  context.go('/');
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ));
                },
                child: SlideInRight(
                  child: Row(
                    children: [
                      Image.asset(
                        Appimages.logouticon,
                        height: 30,
                        color: provider.isdarkmode
                            ? Appcolors.lightcolor
                            : Appcolors.black,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      const Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class settingwidget extends StatelessWidget {
  final VoidCallback ontap;
  final IconData icon;
  final String image;
  final String text;
  final bool isicon;

  const settingwidget({
    this.isicon = true,
    this.icon = Icons.abc,
    this.image = "",
    required this.ontap,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Homeprovider>(builder: (context, provider, _) {
      return GestureDetector(
        onTap: ontap,
        child: Row(
          children: [
            isicon
                ? Icon(
                    icon,
                    size: 30,
                    color: provider.isdarkmode
                        ? Appcolors.lightcolor
                        : Appcolors.black,
                  )
                : Image.asset(
                    image,
                    scale: 16,
                    color: provider.isdarkmode
                        ? Appcolors.lightcolor
                        : Appcolors.black,
                  ),
            const SizedBox(
              width: 18,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 22,
                  color: provider.isdarkmode
                      ? Appcolors.lightcolor
                      : Appcolors.black),
            ),
          ],
        ),
      );
    });
  }
}
