import 'package:flutter/material.dart';
import 'package:shared_preference_module/constants/image_constants.dart';
import 'package:shared_preference_module/constants/string_constants.dart';

import 'package:shared_preference_module/helper/authenticationFunctions.dart';
import 'package:shared_preference_module/helper/validationFunctions.dart';
import 'package:shared_preference_module/screens/profile_page.dart';
import 'package:shared_preference_module/screens/sign_up_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color.fromRGBO(27, 213, 210, 10),
                    Color.fromRGBO(27, 213, 210, 15),
                    Color.fromRGBO(27, 213, 210, 20),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Image.asset(ImageConstant.successiveLoginLogo,
                        height: 150, width: 300),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 90.0),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(7.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 7.0,
                                  blurRadius: 5.0,
                                  color: Color.fromRGBO(205, 219, 254, 1)
                                      .withOpacity(0.5),
                                  offset: Offset(0, 3),
                                )
                              ]),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey.shade300),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 10.0),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                    ),
                                    hintText: StringConstants.email,
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  validator: (value) {
                                    return validateEmail(value!);
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => node.nextFocus(),
                                ),
                              ),
                              Container(
                                //padding: EdgeInsets.only(left: 20, right: 20),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 10.0),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                    ),
                                    hintText: StringConstants.password,
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  validator: (value) {
                                    return validatePassword(value!);
                                  },
                                  onEditingComplete: () => node.unfocus(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          width: 370,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 3.0,
                                blurRadius: 5.0,
                                color: Color.fromRGBO(204, 205, 206, 1)
                                    .withOpacity(0.5),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                //checking the credentials
                                List<String> userDetailsList =
                                    await getPersonList(emailController.text);

                                // If user details list is not empty that implies that user exists.
                                if (userDetailsList.isNotEmpty) {
                                  print(userDetailsList);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool(StringConstants.login, true);

                                  prefs.setString(StringConstants.email,
                                      emailController.text);
                                  // checking if password matches
                                  if (userDetailsList.last ==
                                      passwordController.text) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  dataList: userDetailsList,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      StringConstants.INCORRECT_PASSWORD,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    StringConstants.USER_NOT_FOUND,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  )));
                                }
                              }
                            },
                            child: Text(
                              StringConstants.login,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(27, 213, 210, 10)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                ))),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Text(
                            StringConstants.continue_social_media,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImageConstant.FB_ICON,
                              height: 70,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Image.asset(
                              ImageConstant.GOOGLE_ICON,
                              height: 60,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              StringConstants.dont_have_Account_msg,
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()));
                                },
                                child: Text(
                                  StringConstants.signup,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
