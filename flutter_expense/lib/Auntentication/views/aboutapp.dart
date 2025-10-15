import 'package:flutter/material.dart';
import 'package:flutter_expense/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense/App/views/provider/homeprovider.dart';

class Aboutapp extends StatelessWidget {
  const Aboutapp({super.key});

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
                    const Icon(Icons.chevron_left),
                    const SizedBox(width: 110),
                    Text(
                      "About APP",
                      style: TextStyle(
                        fontSize: 30,
                        color: homeProvider.isdarkmode
                            ? Appcolors.lightcolor
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
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
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildText(homeProvider,
                              'Wings is a smart learning app designed to make education engaging and effective. Practice quizzes, track progress, and boost your knowledge—all in one place.'),
                          _buildText(homeProvider,
                              'Perfect for students preparing for competitive exams and school tests.'),
                          _buildText(homeProvider,
                              'Wings is a smart learning app designed to make education engaging and effective. Practice quizzes, track progress, and boost your knowledge—all in one place.'),
                          _buildText(homeProvider,
                              'Perfect for students preparing for competitive exams and school tests.'),
                          _buildText(homeProvider,
                              'Wings is a smart learning app designed to make education engaging and effective. Practice quizzes, track progress, and boost your knowledge—all in one place.'),
                          _buildText(homeProvider,
                              'Perfect for students preparing for competitive exams and school tests.'),
                          _buildText(homeProvider,
                              'Wings is a smart learning app designed to make education engaging and effective. Practice quizzes, track progress, and boost your knowledge—all in one place.'),
                          _buildText(homeProvider,
                              'Perfect for students preparing for competitive exams and school tests.'),
                          _buildText(homeProvider,
                              'Wings is a smart learning app designed to make education engaging and effective. Practice quizzes, track progress, and boost your knowledge—all in one place.'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(Homeprovider provider, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: provider.isdarkmode ? Appcolors.lightcolor : Colors.black87,
        ),
      ),
    );
  }
}
