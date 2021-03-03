abstract class AuthCredentials {
  final String username;
  final String password;
  final String name;
  String id;
  String error;

  AuthCredentials(
      {this.username, this.password, this.name, this.id, this.error});
}

// 2
class LoginCredentials extends AuthCredentials {
  LoginCredentials({String username, String password, error})
      : super(username: username, password: password);
}

// 3
class SignUpCredentials extends AuthCredentials {
  SignUpCredentials({String username, String password, String name})
      : super(username: username, password: password, name: name);
}

class SignedCredentials extends AuthCredentials {
  SignedCredentials({String username, String name})
      : super(username: username, name: name);
}
