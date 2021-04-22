class FormValidator {
  static FormValidator _instance;

  factory FormValidator() => _instance ??= new FormValidator._();

  FormValidator._();

  String validatePassword(String value) {
    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Password es requerida";
    } else if (value.length < 8) {
      return "Password debería tener al menos 8 caracteres";
    } else if (!regExp.hasMatch(value)) {
      return "Password debería tener al menos una letra mayúscula o minúscula, y un dígito.";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "Email es requerido";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }

  String validatePhone(String value) {
    if (value.length != 10) {
      return "El teléfono debe tener 10 dígitos.";
    } else {
      return null;
    }
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return "Nombre es requerido";
    } else {
      return null;
    }
  }

  String validateNull() {
    return null;
  }
}
