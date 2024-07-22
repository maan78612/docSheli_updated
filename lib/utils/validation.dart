class FieldValidator {
  /////////////////////////////////////////////////////////////
  ///////////////////Doctor SignUp validator///////////////////
  ////////////////////////////////////////////////////////////

  static String? validateFullName(String value) {
    if (value.isEmpty) {
      return 'Please enter full name.';
    }
    if (!RegExp(r"^[A-Z a-z-]{2,25}$").hasMatch(value)) {
      return 'Invalid Name';
    }

    return null;
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) return "Please enter phone number.";
    if (value.length <= 8) {
      return "Invalid Number!";
    }

    String pattern = r'(^(?:[+0]9)?[0-9]{9,15}$)';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return "Invalid Number!";
    }
    return null;
  }

  static String? validateQualification(String value) {
    if (value.isEmpty) return "Please enter  your qualification.";

    return null;
  }

  static String? validateLicenseNumber(String value) {
    if (value.isEmpty) return "Please enter your license number.";
    // if (value.length < 5) {
    //   return "Qualification length should be greater than 5.";
    // }
    return null;
  }

  static String? validateSpeciality(String value) {
    if (value.isEmpty) return "Please enter your speciality.";
    if (value.length < 5) {
      return "Speciality length should be greater than 5.";
    }
    return null;
  }

  static String? validateHospital(String value) {
    if (value.isEmpty) return "Please enter your hospital details.";
    if (value.length < 5) {
      return "Hospital length should be greater than 5.";
    }
    return null;
  }

  static String? validateDateOfBirth(String value) {
    if (value.isEmpty) return "Please select your date of birth.";
    return null;
  }

  static String? validateField(String value) {
    if (value.isEmpty) return "Field is empty";
    return null;
  }

  static String? validatePin(String? value) {
    print("validatePin : $value ");

    if (value != null) {
      if (value.isEmpty) return "Enter OTP";

      String pattern = r'^(?=.*?[0-9])(?!.*?[!@#\$&*~+/.,():N]).{6,}$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value.trim())) {
        return "Invalid OTP";
      }
    }

    return null;
  }

  static String? validateExp(String? value) {
    print("validateExp : $value ");

    if (value != null) {
      if (value.isEmpty) return "Enter number of years";
    }

    return null;
  }
}
