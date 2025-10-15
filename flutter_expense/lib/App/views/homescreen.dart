import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expense/App/helper/datehelper.dart';
import 'package:flutter_expense/App/views/add_trans.dart';
import 'package:flutter_expense/App/views/manage_balance.dart';
import 'package:flutter_expense/App/views/provider/homeprovider.dart';
import 'package:flutter_expense/App/views/profile.dart';
import 'package:flutter_expense/App/views/viewall.dart';
import 'package:flutter_expense/Auntentication/views/biometric.dart';
import 'package:flutter_expense/Auntentication/views/loginscreen.dart';
import 'package:flutter_expense/constants/apis.dart';
import 'package:flutter_expense/constants/colors.dart';
import 'package:flutter_expense/constants/images.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// ⬇️ NEW imports for auth button
// import 'package:flutter_expense/Authentication/utils/biometricauth.dart';
// import 'package:flutter_expense/Authentication/views/loginscreen.dart';
// import 'package:flutter_expense/App/views/homepage.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<Homeprovider>();
      await provider.loadid();
      await Future.wait([
        provider.gettransactions(),
        provider.loadprofile(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Homeprovider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor:
            provider.isdarkmode ? Appcolors.darkcolor : Colors.white,
        appBar: AppBar(
          backgroundColor: provider.isdarkmode
              ? const Color.fromARGB(221, 0, 0, 43)
              : Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Profile()));
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: provider.localimage!.isNotEmpty
                          ? FileImage(File(provider.localimage!))
                          : provider.profileimage!.isNotEmpty
                              ? NetworkImage(
                                  Apis.baseurl + provider.profileimage!)
                              : const AssetImage(Appimages.profileicon)
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                          color:
                              provider.isdarkmode ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        provider.name.text,
                        style: TextStyle(
                          color:
                              provider.isdarkmode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.go('/home/settings'),
                child: const Icon(Icons.settings, color: Colors.grey, size: 33),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // =========================
              //  Setup Authentication button
              // =========================
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    Biometricauth().checkBiometric(
                      context,
                      const Homescreen(), // on success
                      const Loginscreen(), // on failure
                      true, // ask to set up if not enrolled
                    );
                  },
                  child: const Text('Setup Authentication'),
                ),
              ),

              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => context.go('/home/manage'),
                child: provider.isloading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.white,
                        child: Container(
                          height: 170,
                          width: 320,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Appcolors.container1,
                              Appcolors.container2,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Total balance',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: provider.isdarkmode
                                    ? Appcolors.darkcolor
                                    : Colors.white,
                              ),
                            ),
                            Text(
                              '\$ ${provider.balance ?? "0"}',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                                color: provider.isdarkmode
                                    ? Appcolors.darkcolor
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.arrow_upward,
                                          color: Colors.lightGreen),
                                    ),
                                    const SizedBox(width: 6),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Income',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: provider.isdarkmode
                                                ? Appcolors.darkcolor
                                                : Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '\$ ${provider.totalCredit}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: provider.isdarkmode
                                                ? Appcolors.darkcolor
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.arrow_downward,
                                          color: Colors.red),
                                    ),
                                    const SizedBox(width: 6),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Expenses',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: provider.isdarkmode
                                                ? Appcolors.darkcolor
                                                : Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '\$ ${provider.totalDebit}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: provider.isdarkmode
                                                ? Appcolors.darkcolor
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color:
                          provider.isdarkmode ? Colors.white : Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/home/viewall'),
                    child: Text(
                      'View all',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: provider.isdarkmode
                            ? Appcolors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.debittransactions.length,
                  itemBuilder: (_, index) {
                    return provider.isloading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.white,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 70,
                              width: 320,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 42,
                                      width: 42,
                                      decoration: BoxDecoration(
                                        color: provider.getCategoryColor(
                                            provider.debittransactions[index]
                                                .category),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                          provider.getcategoryimage(provider
                                              .debittransactions[index]
                                              .category)),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      provider
                                          .debittransactions[index].category,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: provider.isdarkmode
                                            ? Appcolors.lightcolor
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$ ${provider.debittransactions[index].amount}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: provider.isdarkmode
                                            ? Appcolors.lightcolor
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      DateHelper.getRelativeDate(provider
                                          .debittransactions[index]
                                          .transactionDate),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: provider.isdarkmode
                                            ? Appcolors.lightcolor
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
