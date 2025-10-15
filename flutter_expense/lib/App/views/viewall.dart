import 'package:flutter/material.dart';
import 'package:flutter_expense/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense/App/views/provider/homeprovider.dart';
import 'package:flutter_expense/App/helper/datehelper.dart';

class Viewall extends StatelessWidget {
  const Viewall({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Homeprovider>(context);

    return Scaffold(
      backgroundColor:
          provider.isdarkmode ? Appcolors.darkcolor : Appcolors.white,
      appBar: AppBar(
        backgroundColor:
            provider.isdarkmode ? Appcolors.darkcolor : Appcolors.white,
        title: Text(
          "All Transactions",
          style: TextStyle(
            color: provider.isdarkmode
                ? Appcolors.lightcolor
                : Appcolors.darkcolor,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: provider.debittransactions.length,
        itemBuilder: (context, index) {
          final transaction = provider.debittransactions[index];

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey,
              ),
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
                        color: provider.getCategoryColor(transaction.category),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        provider.getcategoryimage(transaction.category),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      transaction.category,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: provider.isdarkmode
                            ? Appcolors.lightcolor
                            : Appcolors.darkcolor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$ ${transaction.amount}",
                      style: TextStyle(
                        fontSize: 18,
                        color: provider.isdarkmode
                            ? Appcolors.lightcolor
                            : Appcolors.darkcolor,
                      ),
                    ),
                    Text(
                      DateHelper.getRelativeDate(transaction.transactionDate),
                      style: TextStyle(
                        fontSize: 16,
                        color: provider.isdarkmode
                            ? Appcolors.lightcolor
                            : Appcolors.darkcolor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
