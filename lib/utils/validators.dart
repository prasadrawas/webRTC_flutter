class Validator {
  static String? validateEmail(String? email) {
    return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email ?? '')
        ? null
        : 'Invalid email';
  }

  static String? validateName(String? name) {
    if (name!.length < 3) {
      return 'Invalid name';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Invalid Password';
    }

    if (password.length < 6) {
      return 'Weak Password';
    } else {
      return null;
    }
  }

  static String? validateSignInPassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Invalid Password';
    }
  }

  static String? validatePhone(String? phone) {
    if (phone!.length < 10 || phone.length > 10 || phone.startsWith('0')) {
      return 'Invalid phone number';
    } else {
      return null;
    }
  }
}
