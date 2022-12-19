import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preference_module/constants/image_constants.dart';
import 'package:shared_preference_module/constants/string_constants.dart';

import 'package:shared_preference_module/helper/personDatabaseHelper.dart';
import 'package:shared_preference_module/helper/validationFunctions.dart';
import 'package:shared_preference_module/models/personModel.dart';
import 'package:shared_preference_module/screens/login_page.dart';

import "package:intl/intl.dart";

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

String gender = StringConstants.male;

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime? _birthDate;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      //appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.95,
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 80, bottom: 20),
                  child: Column(children: [
                    Image.asset(
                      ImageConstant.successiveSignupLogo,
                      height: 80.0,
                      width: 80.0,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: StringConstants.fullname,
                        prefixIcon: Padding(
                            padding: EdgeInsetsDirectional.only(start: 10),
                            child: Icon(Icons.person)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      validator: (value) {
                        return validateName(value!);
                      },
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: StringConstants.email,
                        prefixIcon: Padding(
                          padding: EdgeInsetsDirectional.only(start: 10),
                          child: Icon(Icons.email),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      validator: (value) {
                        return validateEmail(value!);
                      },

                      // to shift the focus to next textfield or widget.
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: StringConstants.phone_number,
                        prefixIcon: Padding(
                            padding: EdgeInsetsDirectional.only(start: 10),
                            child: Icon(Icons.phone)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      validator: (value) {
                        return validatePhoneNumber(value!);
                      },
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      //controller: dateController,
                      //keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: _birthDate == null
                            ? StringConstants.dob
                            : dateFormat.format(_birthDate!).toString(),
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1970),
                                lastDate: DateTime(2025))
                            .then((date) {
                          setState(() {
                            _birthDate = date!;
                          });
                        });
                      },
                      validator: (date) {
                        if (_birthDate == null) {
                          return "Please enter your date of birth.";
                        }
                        int age = (DateTime.now().year - _birthDate!.year);
                        if (age < 20) {
                          return "Your age is below 20, so you can't register.";
                        }
                        return null;
                      },

                      // to shift the focus to next textfield or widget.

                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: StringConstants.create_password,
                        prefixIcon: Padding(
                            padding: EdgeInsetsDirectional.only(start: 10),
                            child: Icon(Icons.lock)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      validator: (value) {
                        return validatePassword(value!);
                      },
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: confirmPassController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: StringConstants.confirm_password,
                        prefixIcon: Padding(
                            padding: EdgeInsetsDirectional.only(start: 10),
                            child: Icon(Icons.lock)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required.";
                        }
                        if (value != passController.value.text) {
                          return "Password do not match.";
                        }
                        return null;
                      },
                      onEditingComplete: () => node.unfocus(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 510,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Icon(
                            Icons.person,
                            color: Colors.grey[600],
                          ),
                          Text(
                            StringConstants.gender_signup,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                          Radio(
                              value: StringConstants.male,
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              }),
                          Text(StringConstants.male,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 16)),
                          Radio(
                              value: StringConstants.female,
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              }),
                          Text(StringConstants.female,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 16)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: 510,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            debugPrint("Details are validated!!");
                            debugPrint("Full Name: " + nameController.text);
                            debugPrint("Email ID: " + emailController.text);
                            debugPrint("Date of Birth: " +
                                dateFormat.format(_birthDate!).toString());
                            debugPrint("Gender: " + gender.toString());

                            print("Phone Number: " +
                                phoneController.text.toString());
                            debugPrint("Account Created!!!!!!!");

                            // Creating a new variable
                            var personObject = Person(
                                nameController.text.toString(),
                                emailController.text.toString(),
                                phoneController.text,
                                passController.text.toString(),
                                dateFormat.format(_birthDate!).toString(),
                                gender);
                            // Initialising database instance
                            PersonDatabaseHelper person =
                                new PersonDatabaseHelper();
                            await person.initializeDatabase();

                            // Inserting the person details
                            await person.insertPerson(personObject);

                            // After insertion user will be navigated to login page
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          }
                        },
                        child: Text(
                          StringConstants.signup,
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(27, 213, 210, 10)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ))),
                      ),
                    ),

                    /*SizedBox(
                      height: 5.0,
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringConstants.already_have_account,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text(
                              StringConstants.signin,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ]),
                )),
          ),
        ),
      ),
    );
  }
}
