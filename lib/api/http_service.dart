import 'package:inventi_app/api/env.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../accounts/secure_storage.dart';
import 'models.dart';

class HttpService {
  Future<Login> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse("${Env.BASE_URL}/api/auth/login/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return Login.fromJson(jsonDecode(response.body));
    } else {
      throw Login.onError(jsonDecode(response.body));
    }
  }

  Future<Logout> logout({required String userToken}) async {
    final response = await http.post(
      Uri.parse("${Env.BASE_URL}/api/auth/logout/"),
      headers: {'Authorization': 'Token $userToken'},
    );

    if (response.statusCode == 204) {
      return Logout.http204();
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }

  Future<RegisterModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("${Env.BASE_URL}/api/auth/register/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return RegisterModel.fromJson(jsonDecode(response.body));
    } else {
      throw RegisterModel.onError(jsonDecode(response.body));
    }
  }

  Future<User> user({required String userToken}) async {
    final response = await http.get(
      Uri.parse("${Env.BASE_URL}/api/auth/user/"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $userToken',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future authenticate() async {
    var token = await UserSecureStorage.getToken();
    // ignore: unnecessary_null_comparison
    if (token == '') {
      return false; // then proceed the login page
    } else {
      final response = await http.get(
        Uri.parse("${Env.BASE_URL}/api/auth/user/"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
      ).onError((error, _) {
        return http.Response(error.toString(), 408);
      });

      // if (response.statusCode == 401) {
      //   return http.Response(response.body, response.statusCode);
      // } else if (response.statusCode == 401) {
      //   return http.Response(response.body, response.statusCode);
      // }
      // .timeout(
      //   const Duration(seconds: 10),
      //   onTimeout: () {
      //     return http.Response('Connection timed out', 408);
      //   },
      // );

      return response;
    }
  }

  Future<TextGenerated> generateText() async {
    final response = await http.get(
      Uri.parse(Env.TEXT_GENERATOR_URL),
    );

    if (response.statusCode == 200) {
      return TextGenerated.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to generate text.');
    }
  }
}
