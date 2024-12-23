class Validator {
  static final _email = RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

  static bool isEmail(String str) {
    return Validator._email.hasMatch(str.toLowerCase());
  }

  static bool isUrl(String str) {
    Uri uri = Uri.parse(str);
    bool valid = uri.isAbsolute && uri.host.isNotEmpty;
    return valid;
  }

  static bool isPhoneNumber(String isoCode, String phoneNumber) {
    return true;
  }

  static String checkPasswordValidity(String password, [int minLength = 6]) {
    if (password == null || password.isEmpty) {
      return "Password should be atleast 6 characters.";
    }

    // bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    // bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    // bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    // bool hasSpecialCharacters =
    //     password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasNoSpace = !password.contains(' ');
    if (!hasNoSpace) {
      return "Password should not have space.";
    }

    bool hasMinLength = password.length >= minLength;
    if (!hasMinLength) {
      return "Password should be atleast 6 characters.";
    }

    return null;
  }
}
