import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User.dart';

class ApiService {
  final String baseUrl = 'https://dummyjson.com';


  Future<List<User>> fetchUsers({
    int limit = 10,
    int skip = 0,
    String? search,
  }) async {
    final url = search != null && search.isNotEmpty
        ? '$baseUrl/users/search?q=$search&limit=$limit&skip=$skip'
        : '$baseUrl/users?limit=$limit&skip=$skip';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception('Failed to load users');

    final data = json.decode(response.body);
    return List<User>.from(data['users'].map((json) => User.fromJson(json)));
  }


  Future<User> fetchUserDetail(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode != 200) throw Exception('Failed to fetch user details');
    final data = json.decode(response.body);
    return User.fromJson(data);
  }


  Future<List<String>> fetchPosts(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/user/$userId'));
    if (response.statusCode != 200) throw Exception('Failed to fetch posts');
    final data = json.decode(response.body);
    return List<String>.from(data['posts'].map((post) => post['title']));
  }

  Future<List<String>> fetchTodos(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/todos/user/$userId'));
    if (response.statusCode != 200) throw Exception('Failed to fetch todos');
    final data = json.decode(response.body);
    return List<String>.from(data['todos'].map((todo) => todo['todo']));
  }
}
