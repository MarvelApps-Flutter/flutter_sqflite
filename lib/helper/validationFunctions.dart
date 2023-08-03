// Function to validate password
validatePassword(String value) {
  if (value.isEmpty) {
    return "Password is required.";
  }
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'; //Password validation regular expression.
  RegExp regExp = new RegExp(pattern);

  if (!regExp.hasMatch(value)) {
    return "Password must contain atleast 1 uppercase, min. 1 lowercase, 1 special character, min. 1 numeric char.";
  } else if (value.length < 8) {
    return "Password should atleast be of 8 characters.";
  }
}

// Function to validate name.
validateName(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter your full name.";
  }
}

// Function to validate email
validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter your email.";
  }

  const emailPattern =
      r'[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Email validation regular expression
  final regEx = RegExp(emailPattern);

  if (!regEx.hasMatch(value)) {
    return "Enter a valid email ID.";
  }
}

// Function to validate phone number
validatePhoneNumber(String value) {
  if (value.isEmpty) {
    return "Please enter your number.";
  }
  String numPattern = r'^[0-9]+$'; //Phone Number validation regular expression.
  RegExp regExp = new RegExp(numPattern);

  if (!regExp.hasMatch(value)) {
    return "Invalid number format.";
  } else if (value.length < 10 || value.length > 10) {
    return "Number should be of 10 digits.";
  }
}
