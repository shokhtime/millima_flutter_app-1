import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:millima/data/models/register_request.dart';
import 'package:millima/services/authentication_service.dart';

void main() async {
  final auth = AuthenticationService();

  // Sign up a new user
  try {
    final signUpResponse = await auth.signUp(
      const RegisterRequest(
        name: "Alex",
        phone: "998901112233",
        password: "12345678",
        passwordConfirmation: "12345678",
      ),
    );
    print('User signed up: ${signUpResponse['user']}');
  } on DioException catch (e) {
    print(e);
    print(e.response?.data);
  } catch (e) {
    print('Error during sign up: $e');
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
