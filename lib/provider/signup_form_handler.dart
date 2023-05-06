class SignUpFormHandler {
  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'please enter your name';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return ' email can not be embty';
    }
    if (!value.contains('@')) {
      return 'please, enter valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty || value == null) {
      return "Password can't be  empty";
    }
    if (value.length < 4) {
      return 'password length must be at least 4';
    }
    if (value.length > 20) {
      return 'password length must not be greater than 20';
    }

    return null;
  }

}
