import 'package:dio/dio.dart';
import 'package:territorio/models/user.dart';

class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<void> fetchSaveUser(User request, String token) async {
    await dio.post("https://territorio-api.herokuapp.com/users",
        data: request.toJson(),
        options: Options(headers: {"Authorization": "Bearer $token"}));
  }

  Future<List<User>> fetchListUsers(String token) async {
    final response = await dio.get("https://territorio-api.herokuapp.com/users",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    final list = response.data as List;
    return list.map((e) => User.fromJson(e)).toList();
  }

  Future<int> fetchRemoveUser(int id, String token) async {
    final response = await dio.delete(
        "https://territorio-api.herokuapp.com/users/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    if (response.statusCode == 200) {
      return 1;
    }
    return 0;
  }
}
