class CreateUserFormHandler {
  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'please enter your name';
    }
    return null;
  }

 static String? jobValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'please enter your job';
    }
    return null;
  }
}
