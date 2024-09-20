// GET
class User {
  final int id;
  final String username;
  final String email;

  User({required this.id, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> data) => User(
        id: data['id'],
        username: data['username'],
        email: data['email'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
      };
}

// POST
class RegisterModel {
  final Map<String, dynamic> user; // contains id, username, email
  final String token;
  final Map<String, dynamic>? errorMsg;

  RegisterModel({required this.user, required this.token, this.errorMsg});

  factory RegisterModel.fromJson(Map<String, dynamic> data) => RegisterModel(
        user: data['user'],
        token: data['token'],
      );

  factory RegisterModel.onError(Map<String, dynamic>? data) => RegisterModel(
        errorMsg: data,
        token: '',
        user: {},
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "token": token,
      };
}

// POST
class Login {
  final Map<String, dynamic> user; // contains id, username, email
  final String token;
  final Map<String, dynamic>? errorMsg;

  Login({required this.user, required this.token, this.errorMsg});

  factory Login.fromJson(Map<String, dynamic> data) => Login(
        user: data['user'],
        token: data['token'],
      );

  factory Login.onError(Map<String, dynamic>? data) => Login(
        errorMsg: data,
        token: '',
        user: {},
      );

  Map<String, dynamic> get toJson => {
        "user": user,
        "token": token,
      };
}

// POST
class Logout {
  String? http204Message;
  Logout({this.http204Message});

  factory Logout.http204() => Logout(http204Message: 'Logout success.');
}

// GET
class TextGenerated {
  final String randomString;

  TextGenerated({required this.randomString});

  factory TextGenerated.fromJson(Map<String, dynamic> data) => TextGenerated(
        randomString: data['randomString'],
      );

  Map<String, dynamic> toJson() => {
        "randomString": randomString,
      };
}
