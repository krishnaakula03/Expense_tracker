import 'package:flutter/material.dart';
import 'package:flutter_expense/App/views/provider/homeprovider.dart';
import 'package:flutter_expense/constants/colors.dart';
import 'package:provider/provider.dart';

class Privacypolicy extends StatelessWidget {
  const Privacypolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<Homeprovider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            homeProvider.isdarkmode ? Appcolors.darkcolor : Appcolors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.chevron_left,
                    ),
                    const SizedBox(width: 90),
                    Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontSize: 30,
                        color: homeProvider.isdarkmode
                            ? Appcolors.lightcolor
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: homeProvider.isdarkmode
                        ? Appcolors.darkcolor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText(homeProvider,
                            "We value your privacy. This Privacy Policy explains how we collect, use, and protect your personal information when you use our app."),
                        const SizedBox(height: 10),
                        _buildTitle(homeProvider, "1. Information We Collect"),
                        const SizedBox(height: 10),
                        _buildText(homeProvider,
                            '• Personal Information: Name, email address, and contact details (only if provided by the user).'),
                        _buildText(homeProvider,
                            '• Usage Data: App interactions, device type, and IP address.'),
                        const SizedBox(height: 20),
                        _buildTitle(homeProvider, "2. How We Use Information"),
                        _buildText(homeProvider,
                            '• To provide and improve our services.'),
                        _buildText(homeProvider,
                            '• To communicate important updates or offers.'),
                        _buildText(homeProvider,
                            '• To analyze usage and improve user experience.'),
                        const SizedBox(height: 20),
                        _buildTitle(homeProvider, "3. Data Security"),
                        _buildText(homeProvider,
                            'We implement reasonable measures to protect your data from unauthorized access. However, no method is 100% secure.'),
                        const SizedBox(height: 20),
                        _buildTitle(homeProvider, "4. Third-Party Services"),
                        _buildText(homeProvider,
                            'We may use third-party services (e.g., analytics, ads) which may collect data according to their own privacy policies.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(Homeprovider provider, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: provider.isdarkmode ? Appcolors.lightcolor : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTitle(Homeprovider provider, String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: provider.isdarkmode ? Appcolors.lightcolor : Colors.black,
      ),
    );
  }
}
