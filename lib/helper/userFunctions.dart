import 'package:flutter/material.dart';
import 'package:flutter_sqflite/helper/authenticationFunctions.dart';
import 'package:flutter_sqflite/helper/personDatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/string_constants.dart';
import '../models/personModel.dart';
import '../screens/login_page.dart';
import '../screens/profile_page.dart';

class UserFunctions {
  // User Registration Function
  Future registerUser(
    BuildContext context,
    Person personData,
  ) async {
    try {
      debugPrint("Details are validated!!");

      // Initialising database instance
      PersonDatabaseHelper person = new PersonDatabaseHelper();
      await person.initializeDatabase();

      // Inserting the person details
      await person.insertPerson(personData);

      // After insertion user will be navigated to login page
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            StringConstants.SOMETHING_WENT_WRONG,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  // User Login Function
  Future login(
      BuildContext context, String userEmail, String userPassword) async {
    try {
      //checking the credentials
      List<String> userDetailsList = await getPersonList(userEmail);

      // If user details list is not empty that implies that user exists.
      if (userDetailsList.isNotEmpty) {
        print(userDetailsList);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(StringConstants.login, true);

        prefs.setString(StringConstants.email, userEmail);
        // checking if password matches
        if (userDetailsList.last == userPassword) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        dataList: userDetailsList,
                      )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            StringConstants.INCORRECT_PASSWORD,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          )));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          StringConstants.USER_NOT_FOUND,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        )));
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            StringConstants.SOMETHING_WENT_WRONG,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  // Update User details function
  Future updateUserDetails(BuildContext context, Person personData) async {
    try {
      // Initialising database instance
      PersonDatabaseHelper person = new PersonDatabaseHelper();
      await person.initializeDatabase();

      // Inserting the person details
      var test = await person.updatePerson(personData);

      print(test);
      List<String> personDetails = await getPersonList(personData.email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(StringConstants.login, true);

      prefs.setString(StringConstants.email, personData.email);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    dataList: personDetails,
                  )));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            StringConstants.UPDATED_SUCCESSFULLY,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            StringConstants.SOMETHING_WENT_WRONG,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  // Log out function
  Future logoutUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(StringConstants.login, false);
      prefs.setString(StringConstants.email, "");

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            StringConstants.SOMETHING_WENT_WRONG,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  // Delete User Account
  Future deleteAccount(BuildContext context, String userEmail) async {
    try {
      // Initialising database instance
      PersonDatabaseHelper person = new PersonDatabaseHelper();
      await person.initializeDatabase();

      // Inserting the person details
      var test = await person.deletePerson(userEmail);

      print(test);

      // After insertion user will be navigated to login page
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(StringConstants.login, false);
      prefs.setString(StringConstants.email, "");

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            StringConstants.ACCOUNT_DELETED_SUCCESSFULLY,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            StringConstants.SOMETHING_WENT_WRONG,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
