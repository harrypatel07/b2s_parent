import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:validators/validators.dart';

class Validator {
  static String validateEmail(String email) {
    if (email == null || email.trim() == "") return translation.text("COMMON.EMAIL_REQUITE");
    var isValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (!isValid) return translation.text("COMMON.EMAIL_INVALID");
    return null;
  }

  static String validatePassword(String pass) {
    if (pass == null || pass.trim() == "")
      return translation.text("COMMON.PASS_REQUITE");
    else if (pass.length < 6) return translation.text("COMMON.PASS_REQUITE_LENGTH");
    return null;
  }

  static String validateURL(String url) {
    if (url == null || url.trim() == "") return translation.text("COMMON.URL_REQUITE");
    var isValid = isURL(url, requireTld: false);
    if (!isValid) return translation.text("COMMON.URL_INVALID");
    return null;
  }

//  static String validatePhone(String phone) {
//    if (phone == null || phone.trim() == "") return translation.text("COMMON.PHONE_REQUITE");
//    var isValid = RegExp(
//            r"^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$")
//        .hasMatch(phone);
//    if (!isValid) return translation.text("COMMON.PHONE_INVALID");
//    return null;
//  }
  static String validatePhone(String phone) {
    if (phone == null || phone.trim() == "") return translation.text("COMMON.PHONE_REQUITE");
    else if(phone.length<1) return translation.text("COMMON.PHONE_REQUITE");
    return null;
  }
  static String validateName(String name) {
    if (name == null || name == "") return translation.text("COMMON.NAME_REQUITE");
    else if(name.length<1) return translation.text("COMMON.NAME_REQUITE");
    return null;
  }
  static String validateBirthDay(String birthday) {
    if (birthday == null || birthday == "") return translation.text("COMMON.BIRTH_REQUITE");
    else if(birthday.length<1) return translation.text("COMMON.BIRTH_REQUITE");
    return null;
  }
  static String validateGender(String gender) {
    if (gender == null || gender == "") return translation.text("COMMON.GENDER_REQUITE");
    else if(gender.length<1) return translation.text("COMMON.GENDER_REQUITE");
    return null;
  }
  static String validateSchoolName(String schoolName) {
    if (schoolName == null || schoolName == "") return translation.text("COMMON.SCHOOL_REQUITE");
    else if(schoolName.length<1) return translation.text("COMMON.SCHOOL_REQUITE");
    return null;
  }
  static String validateAge(String age) {
    if (age == null || age.trim() == "") return translation.text("COMMON.AGE_REQUITE");
    var isValid =
    RegExp(r"^[0-99]").hasMatch(age);
    if (!isValid) return translation.text("COMMON.AGE_INVALID");
    return null;
  }
  static String validAddress(String address){
    if (address == null || address == '') return translation.text("COMMON.ADDRESS_REQUITE");
    else if(address.length<1) return translation.text("COMMON.ADDRESS_REQUITE");
    return null;
  }
}
