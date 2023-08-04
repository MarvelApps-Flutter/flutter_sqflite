import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preference_module/constants/string_constants.dart';
import 'package:shared_preference_module/helper/userFunctions.dart';
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
  String? phoneNumber;
  String? gender;
  String? birthdate;
  String? password;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();

    // Structure of datalist
    // [user name, user email, user dob, user gender, user phone no., user password]

    name =
        widget.dataList.length == 0 ? StringConstants.name : widget.dataList[0];
    email = widget.dataList.length == 0
        ? StringConstants.email
        : widget.dataList[1];
    gender =
        widget.dataList.length == 0 ? StringConstants.male : widget.dataList[3];
    birthdate =
        widget.dataList.length == 0 ? StringConstants.dob : widget.dataList[2];
    phoneNumber = widget.dataList.length == 0
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
    TextEditingController phoneController = new TextEditingController();
    DateTime _birthDate;
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: appBarSection(context),
      body: profilePageBodySection(context, nameController, node,
          emailController, phoneController, passController),
    );
  }

  SingleChildScrollView profilePageBodySection(
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
                          nameContainer(nameController, node),
                          genderRow(),
                          birthdateContainer(context, node),
                          emailContainer(emailController, node),
                          phoneNumberContainer(phoneController, node),
                          passwordContainer(passController, node),
                          SizedBox(
                            height: 20,
                          ),
                          updateProfileButton(nameController, emailController,
                              phoneController, passController, context),
                          SizedBox(
                            height: 10,
                          ),
                          deleteProfileButton(nameController, emailController,
                              phoneController, passController, context)
                        ],
                      ),
                    )),
              )
            ],
          )),
    );
  }

  InkWell deleteProfileButton(
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController phoneController,
      TextEditingController passController,
      BuildContext context) {
    return InkWell(
      onTap: () async {
        // Delete account
        await UserFunctions().deleteAccount(context, emailController.text);
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

  InkWell updateProfileButton(
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController phoneController,
      TextEditingController passController,
      BuildContext context) {
    return InkWell(
      onTap: () async {
        // Creating a new object for updated user details
        var personData = Person(
            nameController.text.toString(),
            emailController.text.toString(),
            phoneController.text,
            passController.text.toString(),
            birthdate,
            gender);

        // Update user profile function
        await UserFunctions().updateUserDetails(context, personData);
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

  Container passwordContainer(
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

  Container phoneNumberContainer(
      TextEditingController phoneController, FocusScopeNode node) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: TextFormField(
        //readOnly: true,
        controller: phoneNumber != null
            ? (phoneController..text = phoneNumber!)
            : phoneController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: phoneNumber == null
                ? StringConstants.phone_number
                : phoneNumber,
            hintStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.phone),
            enabledBorder: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0)),

        onEditingComplete: () => node.unfocus(),
      ),
    );
  }

  Container emailContainer(
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

  Container birthdateContainer(BuildContext context, FocusScopeNode node) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: TextFormField(
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

  Row genderRow() {
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

  Container nameContainer(
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

  AppBar appBarSection(BuildContext context) {
    return AppBar(
        leading: InkWell(
            onTap: () async {
              // logout function
              await UserFunctions().logoutUser(context);
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
            )),
        title:
            Text("${StringConstants.WELCOME_BACK} ${name?.split(" ").first}"),
        backgroundColor: Color.fromRGBO(27, 213, 210, 10));
  }
}
