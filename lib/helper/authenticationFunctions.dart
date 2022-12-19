import 'package:shared_preference_module/helper/personDatabaseHelper.dart';
import 'package:shared_preference_module/models/personModel.dart';

Future<bool> checkCredentials(String email, String password) async {
  bool value = true;
  PersonDatabaseHelper person = new PersonDatabaseHelper();
  // Initialise the database
  // await person.initializeDatabase();

  // Fetching
  var info = await person.getPerson(email);

  List<Person> listPerson = [];
  info.forEach((element) {
    Person personObj = Person.fromMapObject(element);
    listPerson.add(personObj);
  });

  listPerson.forEach((element) {
    if (element.password == password && element.email == email) {
      value = true;
    }
  });

  return value;
}

// Get list of persons

String? name;
String? email1;
String? gender;
String? birthDate;
String? phoneNumber;
String? password;
getList(List<Person> listPerson) async {
  PersonDatabaseHelper person = new PersonDatabaseHelper();
  var info = await person.getPerson(email1!);

  //listPerson = [];
  info.forEach((element) {
    Person personObj = Person.fromMapObject(element);
    listPerson.add(personObj);
  });
}

//String name;

Future<List<String>> getInfoList(String email) async {
  PersonDatabaseHelper person = new PersonDatabaseHelper();
  var info = await person.getPerson(email);

  List<Person> listPerson = [];
  info.forEach((element) {
    Person personObj = Person.fromMapObject(element);
    listPerson.add(personObj);
  });

  List<String> personInfoList = [];

  listPerson.forEach((element) {
    name = element.fullName;
    personInfoList.add(name!);
    email1 = element.email;
    personInfoList.add(email1!);
    birthDate = element.birthDate;
    personInfoList.add(birthDate!);
    gender = element.gender;
    personInfoList.add(gender!);
    phoneNumber = element.phoneNumber;
    personInfoList.add(phoneNumber!);
    password = element.password;
    personInfoList.add(password!);
  });

  print(personInfoList);

  return personInfoList;
}

Future<List<String>> getPersonList(String email) async {
  List<String> personList;
  personList = await getInfoList(email);
  return personList;
}
