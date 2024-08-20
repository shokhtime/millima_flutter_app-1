import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;

  const RegisterRequest({
    required this.name,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [name, phone, password, passwordConfirmation];

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'phone': phone});
    result.addAll({'password': password});
    result.addAll({'password_confirmation': passwordConfirmation});

    return result;
  }

  factory RegisterRequest.fromMap(Map<String, dynamic> map) {
    return RegisterRequest(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      passwordConfirmation: map['passwordConfirmation'] ?? '',
    );
  }
}
