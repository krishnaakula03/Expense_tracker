import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expense/App/views/provider/homeprovider.dart';
import 'package:flutter_expense/constants/apis.dart';
import 'package:flutter_expense/constants/colors.dart';
import 'package:flutter_expense/constants/images.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formkey = GlobalKey<FormState>();

  DateTime? dateOfBirth;
  File? image;

  pickimage() async {
    final imagepicker = ImagePicker();
    final pickedFile = await imagepicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final provider = Provider.of<Homeprovider>(context, listen: false);

      setState(() {
        image = File(pickedFile.path);
        provider.localimage = image!.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Homeprovider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor:
            provider.isdarkmode ? Appcolors.darkcolor : Appcolors.white,
        appBar: AppBar(
          backgroundColor:
              provider.isdarkmode ? Appcolors.darkcolor : Appcolors.white,
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: provider.isdarkmode ? Appcolors.white : null,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        pickimage();
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: provider.localimage!.length > 1
                                ? FileImage(File(provider.localimage!))
                                : provider.profileimage!.length > 1
                                    ? NetworkImage(
                                        Apis.baseurl + provider.profileimage!)
                                    : const AssetImage(Appimages.profileicon),
                          ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, bottom: 4),
                    child: Text(
                      "First Name:",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            provider.isdarkmode ? Appcolors.lightcolor : null,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: provider.isdarkmode ? Appcolors.lightcolor : null,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your name";
                      }
                      return null;
                    },
                    controller: provider.name,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14, bottom: 4, top: 12),
                    child: Text(
                      "Email id:",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            provider.isdarkmode ? Appcolors.lightcolor : null,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: provider.isdarkmode ? Appcolors.lightcolor : null,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter an email";
                      }
                      if (!value.contains('@')) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    controller: provider.email,
                    decoration: InputDecoration(
                      hintText: 'Enter your email id',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14, bottom: 4, top: 12),
                    child: Text(
                      "Mobile Number:",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            provider.isdarkmode ? Appcolors.lightcolor : null,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: provider.isdarkmode ? Appcolors.lightcolor : null,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your mobile number";
                      }

                      return null;
                    },
                    controller: provider.mobile,
                    decoration: InputDecoration(
                      hintText: 'Enter your Mobile Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14, bottom: 4, top: 12),
                    child: Text(
                      "Date of Birth:",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            provider.isdarkmode ? Appcolors.lightcolor : null,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: dateOfBirth ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (pickedDate != null) {
                        setState(() {
                          dateOfBirth = pickedDate;
                          provider.dob.text = pickedDate.toString();
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        validator: (value) {
                          if (provider.dob.text.isEmpty) {
                            return "Select a date";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_month),
                          hintStyle: TextStyle(
                            color: provider.isdarkmode
                                ? Appcolors.lightcolor
                                : null,
                          ),
                          hintText: provider.dob.text.isEmpty
                              ? 'Date'
                              : provider.dob.text.substring(0, 10),
                          // : '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        provider.updateprofilewithPhoto(photofile: image);
                        provider.saveprofile(context);
                      }
                    },
                    child: Container(
                      height: 53,
                      width: 370,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Save changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
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
    });
  }
}
