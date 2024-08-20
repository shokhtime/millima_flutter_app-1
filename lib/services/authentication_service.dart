import 'package:dio/dio.dart';
import 'package:millima/data/models/register_request.dart';

class AuthenticationService {
  final String baseUrl = 'http://millima.flutterwithakmaljon.uz/api';

  Future<Map<String, dynamic>> signUp(RegisterRequest request) async {
    final dio = Dio();
    final url = '$baseUrl/register';

    final response = await dio.post(
      url,
      data: request.toMap(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final dio = Dio();
    final url = '$baseUrl/login';

    final response = await dio.post(
      url,
      data: {
        'email': email,
        'password': password,
      },
    );

    return _handleResponse(response);
  }

  Future<void> signOut(String accessToken) async {
    final dio = Dio();
    final url = '$baseUrl/logout';

    final response = await dio.post(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to sign out: ${response.statusCode}');
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    final Map<String, dynamic> decoded = response.data;
    if (response.statusCode != 200) {
      throw Exception('Failed request: ${decoded['message']}');
    }
    return decoded;
  }
}
