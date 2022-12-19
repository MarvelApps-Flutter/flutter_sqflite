import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preference_module/constants/string_constants.dart';
import 'package:shared_preference_module/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/authenticationFunctions.dart';
import '../helper/personDatabaseHelper.dart';
import '../models/personModel.dart';

class ProfilePage extends StatefulWidget {
  final List<String> dataList;
  ProfilePage({required this.dataList});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? phone_number;
  String? gender;
  String? birthdate;
  String? password;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();

    // Structure of datalist
    //[Jigyasa, jig@gmail.com, 1999-11-14, Female, 9654707498, Abc123##]
    name =
        widget.dataList.length == 0 ? StringConstants.name : widget.dataList[0];
    email = widget.dataList.length == 0
        ? StringConstants.email
        : widget.dataList[1];
    gender =
        widget.dataList.length == 0 ? StringConstants.male : widget.dataList[3];
    birthdate =
        widget.dataList.length == 0 ? StringConstants.dob : widget.dataList[2];
    phone_number = widget.dataList.length == 0
        ? StringConstants.phone_number
        : widget.dataList[4];
    password = widget.dataList.length == 0
        ? StringConstants.password
        : widget.dataList[5];
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = new TextEditingController();
    TextEditingController emailController = new TextEditingController();
    TextEditingController passController = new TextEditingController();
    TextEditingController confirmPassController = new TextEditingController();
    TextEditingController phoneController = new TextEditingController();
    DateTime _birthDate;
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: app_bar_section(context),
      body: profile_page_body_Section(context, nameController, node,
          emailController, phoneController, passController),
    );
  }

  SingleChildScrollView profile_page_body_Section(
      BuildContext context,
      TextEditingController nameController,
      FocusScopeNode node,
      TextEditingController emailController,
      TextEditingController phoneController,
      TextEditingController passController) {
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(27, 213, 210, 10),
            Color.fromRGBO(27, 213, 210, 15),
            Color.fromRGBO(27, 213, 210, 20),
          ])),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Center(
                  child: Text(name![0].toUpperCase(),
                      style: TextStyle(color: Colors.red, fontSize: 40)),
                ),
                //height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(bottom: 10, top: 50),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40))),
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: 10, top: 10, right: 30, left: 30),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          spreadRadius: 5.0,
                          blurRadius: 5.0,
                          color: Colors.blue.shade200.withOpacity(0.5),
                          offset: Offset(0, 3),
                        )
                      ]),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          name_container(nameController, node),

                          gender_row(),
                          birthdate_container(context, node),

                          email_container(emailController, node),
                          //SizedBox(height: 20),
                          phone_number_container(phoneController, node),

                          password_container(passController, node),
                          SizedBox(
                            height: 20,
                          ),
                          update_profile_button(nameController, emailController,
                              phoneController, passController, context),
                          SizedBox(
                            height: 10,
                          ),
                          delete_profile_button(nameController, emailController,
                              phoneController, passController, context)
                        ],
                      ),
                    )),
              )
            ],
          )),
    );
  }

  InkWell delete_profile_button(
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController phoneController,
      TextEditingController passController,
      BuildContext context) {
    return InkWell(
      onTap: () async {
        debugPrint("Details are validated!!");
        debugPrint("Full Name: " + nameController.text);
        debugPrint("Email ID: " + emailController.text);
        // debugPrint("Date of Birth: " +
        //     dateFormat.format(_birthDate!).toString());
        debugPrint("Gender: " + gender.toString());

        print("Phone Number: " + phoneController.text.toString());
        debugPrint("Account Created!!!!!!!");

        // Creating a new variable
        var personObject = Person(
            nameController.text.toString(),
            emailController.text.toString(),
            phoneController.text,
            passController.text.toString(),
            birthdate,
            // dateFormat.format(_birthDate!).toString(),
            gender);
        // Initialising database instance
        PersonDatabaseHelper person = new PersonDatabaseHelper();
        await person.initializeDatabase();

        // Inserting the person details
        var test = await person.deletePerson(emailController.text);

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
              "Account Deleted Successfully !!!",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      child: Container(
        width: 250,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Text(
          StringConstants.DELETE,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  InkWell update_profile_button(
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController phoneController,
      TextEditingController passController,
      BuildContext context) {
    return InkWell(
      onTap: () async {
        debugPrint("Details are validated!!");
        debugPrint("Full Name: " + nameController.text);
        debugPrint("Email ID: " + emailController.text);
        // debugPrint("Date of Birth: " +
        //     dateFormat.format(_birthDate!).toString());
        debugPrint("Gender: " + gender.toString());

        print("Phone Number: " + phoneController.text.toString());
        debugPrint("Account Created!!!!!!!");

        // Creating a new variable
        var personObject = Person(
            nameController.text.toString(),
            emailController.text.toString(),
            phoneController.text,
            passController.text.toString(),
            birthdate,
            // dateFormat.format(_birthDate!).toString(),
            gender);
        // Initialising database instance
        PersonDatabaseHelper person = new PersonDatabaseHelper();
        await person.initializeDatabase();

        // Inserting the person details
        var test = await person.updatePerson(personObject);

        print(test);
        List<String> personDetails =
            await getPersonList(emailController.text.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(StringConstants.login, true);

        prefs.setString(StringConstants.email, emailController.text);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      dataList: personDetails,
                    )));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Updated Successfully!!!",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      child: Container(
        width: 250,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color.fromRGBO(27, 213, 210, 10),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          StringConstants.SAVE,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Container password_container(
      TextEditingController passController, FocusScopeNode node) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: TextFormField(
        //readOnly: true,
        controller: password != null
            ? (passController..text = password!)
            : passController,
        decoration: InputDecoration(
            hintText: password == null
                ? StringConstants.password
                : StringConstants.password,
            hintStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.lock),
            enabledBorder: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0)),
        //textInputAction: TextInputAction.next,
        onEditingComplete: () => node.unfocus(),
      ),
    );
  }

  Container phone_number_container(
      TextEditingController phoneController, FocusScopeNode node) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: TextFormField(
        //readOnly: true,
        controller: phone_number != null
            ? (phoneController..text = phone_number!)
            : phoneController,
        decoration: InputDecoration(
            hintText: phone_number == null
                ? StringConstants.phone_number
                : phone_number,
            hintStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.phone),
            enabledBorder: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0)),
        //textInputAction: TextInputAction.next,
        onEditingComplete: () => node.unfocus(),
      ),
    );
  }

  Container email_container(
      TextEditingController emailController, FocusScopeNode node) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: TextFormField(
        readOnly: true,
        controller:
            email != null ? (emailController..text = email!) : emailController,
        decoration: InputDecoration(
            hintText: email == null ? StringConstants.email : email,
            hintStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.alternate_email),
            enabledBorder: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0)),
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
      ),
    );
  }

  Container birthdate_container(BuildContext context, FocusScopeNode node) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: TextFormField(
        //controller: _birthDate,
        readOnly: true,
        decoration: InputDecoration(
            hintText: birthdate == null ? StringConstants.dob : birthdate,
            hintStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.calendar_today_outlined),
            enabledBorder: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0)),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
      ),
    );
  }

  Row gender_row() {
    return Row(
      children: [
        SizedBox(width: 10),
        Icon(
          Icons.person,
          color: Colors.grey[600],
        ),
        Text(
          StringConstants.gender_signup,
          style: TextStyle(color: Colors.black, fontSize: 16),
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
            style: TextStyle(color: Colors.black, fontSize: 16)),
        Radio(
            value: StringConstants.female,
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value.toString();
              });
            }),
        Text(StringConstants.female,
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ],
    );
  }

  Container name_container(
      TextEditingController nameController, FocusScopeNode node) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: TextFormField(
        controller:
            name != null ? (nameController..text = name!) : nameController,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
            hintText: name == null ? StringConstants.name : name,
            hintStyle: TextStyle(color: Colors.black),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0)),
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
      ),
    );
  }

  AppBar app_bar_section(BuildContext context) {
    return AppBar(
        leading: InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool(StringConstants.login, false);
              prefs.setString(StringConstants.email, "");

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
            )),
        title:
            Text("${StringConstants.WELCOME_BACK} ${name!.split(" ").first}"),
        backgroundColor: Color.fromRGBO(27, 213, 210, 10));
  }
}
