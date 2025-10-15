import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expense/App/models/transactionmodel.dart';

import 'package:flutter_expense/constants/apis.dart';

import 'package:flutter_expense/constants/images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Homeprovider extends ChangeNotifier {
  TextEditingController amount = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController date = TextEditingController();
  String? userid;
  double? balance;

  //dark mode
  bool isdarkmode = false;
  Future<void> toggledarkmode() async {
    isdarkmode = !isdarkmode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('mode', isdarkmode);
    notifyListeners();
  }

  double totalCredit = 0;
  double totalDebit = 0;

  Future<void> calculateTotals() async {
    totalCredit = 0;
    totalDebit = 0;

    for (var txn in alltnx!.data) {
      final amt = double.tryParse(txn.amount) ?? 0;
      if (txn.type == Type.CREDIT) {
        totalCredit += amt;
      } else if (txn.type == Type.DEBIT) {
        totalDebit += amt;
      }
    }
    balance = totalCredit - totalDebit;

    notifyListeners();
  }

  Future<void> transactions(context) async {
    var url = Uri.parse(Apis.baseurl + Apis.addtransactions);

    var response = await http.post(
      url,
      headers: {
        'content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user_id': userid,
        'amount': amount.text.trim(),
        'type': 'debit',
        'category': category.text.trim(),
        'transaction_date': date.text,
      },
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print(res.toString());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('balance', res['balance'].toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res['message'])));
      await gettransactions();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.statusCode.toString())));
    }
    amount.clear();
  }

  bool isloading = false;

  Alltransactions? alltnx;
  List<Datum> debittransactions = [];
  String noid = "No user id";

  Future<void> gettransactions() async {
    isloading = true;
    notifyListeners();
    print("gettransctions $userid ? ? $noid");
    var url = Uri.parse("${Apis.baseurl}${Apis.alltnx}?user_id=$userid");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      alltnx = Alltransactions.fromJson(res);
      debittransactions =
          alltnx!.data.where((txn) => txn.type == Type.DEBIT).toList();
      await calculateTotals();
      notifyListeners();
      print(res.toString());
    }
    isloading = false;
    notifyListeners();
  }

  Future<void> addbalance(context) async {
    var url = Uri.parse(Apis.baseurl + Apis.addtransactions);
    int sum = int.parse(income1.text.isEmpty ? "0" : income1.text) +
        int.parse(income2.text.isEmpty ? "0" : income2.text);
    var response = await http.post(
      url,
      headers: {
        'content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user_id': userid,
        'amount': sum.toString(),
        'type': 'credit',
        'category': 'dummy',
        'transaction_date': 'dummy',
      },
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print(res.toString());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('balance', res['balance'].toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res['message'])));
      await gettransactions();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.statusCode.toString())));
    }
    income1.clear();
    income2.clear();
  }

  String getcategoryimage(String category) {
    switch (category) {
      case 'Food':
        return Appimages.food;
      case 'Shopping':
        return Appimages.shopping;
      case 'Entertainment':
        return Appimages.entertainment;
      case 'Travel':
        return Appimages.travel;
      default:
        return Appimages.others;
    }
  }

  getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'shopping':
        return Colors.purple;
      case 'entertainment':
        return Colors.red;
      case 'travel':
        return Colors.lightGreen;
      default:
        return Colors.white;
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController dob = TextEditingController();
  String? profileimage;
  String? localimage;

  saveprofile(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name.text.trim().toString());
    await prefs.setString('email', email.text.trim().toString());
    await prefs.setString('mobile_no', mobile.text.trim().toString());
    await prefs.setString('dob', dob.text.toString());
    await prefs.setString('photo', profileimage ?? "");
    await prefs.setString('locolphoto', localimage ?? "");
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Details saved")));
  }

  loadid() async {
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('id') ?? "";
    print(userid!);
    notifyListeners();
  }

  Future<void> loadprofile() async {
    final prefs = await SharedPreferences.getInstance();
    name.text = prefs.getString('name') ?? "";
    email.text = prefs.getString('email') ?? "";
    mobile.text = prefs.getString('mobile_no') ?? "";
    dob.text = prefs.getString('dob') ?? "";
    profileimage = prefs.getString('photo') ?? "";

    localimage = prefs.getString('locolphoto') ?? "";
    notifyListeners();
  }

  List<int> amountlist = [];
  List<String> categorylist = [];
  List<String> datelist = [];
  int totalexpenses = 0;

  savetransactions(int amount, String category, String date, context) async {
    amountlist.add(amount);
    categorylist.add(category);
    datelist.add(date);
    this.amount.clear();
    this.category.clear();
    this.date.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categorylist', categorylist);
    await prefs.setStringList('datelist', datelist);
    List<String> stringlist = amountlist.map((e) => e.toString()).toList();
    await prefs.setStringList('amountlist', stringlist);
    if (amountlist.isNotEmpty) {
      totalexpenses = amountlist.reduce((a, b) => a + b);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Data added")));
    notifyListeners();
  }

  // manage balance
  TextEditingController income1 = TextEditingController();
  TextEditingController income2 = TextEditingController();

  saveincome1() async {
    final prefs = await SharedPreferences.getInstance();

    int temp = int.parse(prefs.getString('income1') ?? "0");
    print(temp.toString());
    int temp2 = temp + int.parse(income1.text);
    print(temp2.toString());

    await prefs.setString('income1', temp2.toString());
    income1.clear();
    notifyListeners();
  }

  saveincom2() async {
    final prefs = await SharedPreferences.getInstance();
    int temp = int.parse(prefs.getString('income2') ?? "0");
    int temp2 = temp + int.parse(income2.text);
    await prefs.setString('income2', temp2.toString());
    income2.clear();
    notifyListeners();
  }

  // profile update
  Future<void> updateprofilewithPhoto({
    File? photofile,
  }) async {
    try {
      var request = http.MultipartRequest(
          'post', Uri.parse(Apis.baseurl + Apis.updateprofile));

      if (photofile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo', photofile.path));
      }
      request.fields.addAll({
        'id': userid!,
        'name': name.text.trim(),
        'email': email.text.trim(),
        'mobile_no': mobile.text.trim(),
        'dob': dob.text,
      });
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        print(res["message"].toString());
      } else {
        print("failed to upload ${response.statusCode}");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
