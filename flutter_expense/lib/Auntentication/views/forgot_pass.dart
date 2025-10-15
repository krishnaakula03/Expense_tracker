import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class ForgotPass extends StatelessWidget {
  const ForgotPass({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    context.go('/');
                  },
                  child: const Icon(
                    Icons.chevron_left,
                  )),
              const Text(
                "Forgot Password",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 40),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Please enter your email to reset the password"),
              const SizedBox(
                height: 20,
              ),
              const Text("Your Email"),
              TextFormField(
                  decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Enter your email",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              )),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
