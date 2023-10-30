class FormValidator{
  static String? validateEmptyField(String? str){
    if (str == null || str.trim().isEmpty){
      return "Field cannot be empty";
    }
    return null;
  }

  static String? validatePhoneNumber(String? str){
    final val = validateEmptyField(str);
    if (val != null) return val;
    if (!str!.startsWith("+")){
      return "Example of valid phone number is +2349056088820";
    }
    if (str.length < 7){
      return "Phone number too short";
    }
    return null;
  }
}