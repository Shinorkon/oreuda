import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quest.dart';
import '../models/stats.dart';
import 'auth_service.dart';
import '../config.dart';
import 'health_connect_service.dart';

class ApiService {
  static String get baseUrl =>
      BuildConfig.baseUrl.isNotEmpty
          ? BuildConfig.baseUrl
          : 'http://10.0.2.2:8004';

  static Future<Map<String, String>> get _headers async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> getMe() async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get user: ${res.statusCode}');
  }

  static Future<PlayerStats> getStats() async {
    final res = await http.get(
      Uri.parse('$baseUrl/stats'),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      return PlayerStats.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to get stats: ${res.statusCode}');
  }

  static Future<bool> ping() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'username=$username&password=$password',
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data.containsKey('access_token')) {
      await AuthService.saveToken(data['access_token']);
    }
    return data;
  }

  static Future<Map<String, dynamic>> register(
      String email, String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );
    return jsonDecode(res.body);
  }

  static Future<List<Quest>> getQuests({String? type}) async {
    var url = '$baseUrl/quests';
    if (type != null) url += '?type=$type';
    final res = await http.get(
      Uri.parse(url),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data as List).map((q) => Quest.fromJson(q)).toList();
    }
    throw Exception('Failed to get quests: ${res.statusCode}');
  }

  static Future<List<Quest>> getDailyQuests() async {
    return getQuests(type: 'daily');
  }

  static Future<List<Quest>> checkQuestCompletion() async {
    final res = await http.post(
      Uri.parse('$baseUrl/quests/check'),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['completed'] as List).map((q) => Quest.fromJson(q)).toList();
    }
    // 404 means no quests to check, return empty
    if (res.statusCode == 404) return [];
    throw Exception('Failed to check quests: ${res.statusCode}');
  }

  static Future<void> completeQuest(int questId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/quests/$questId/complete'),
      headers: await _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to complete quest: ${res.statusCode}');
    }
  }

  static Future<void> syncHealth(HealthSnapshot snapshot) async {
    final res = await http.post(
      Uri.parse('$baseUrl/health/sync'),
      headers: await _headers,
      body: jsonEncode({
        'date': DateTime.now().toIso8601String().split('T')[0],
        'steps': snapshot.steps,
        'calories_burned': snapshot.caloriesBurned,
        'sleep_minutes': snapshot.sleepMinutes,
        'resting_hr': snapshot.restingHeartRate,
        'workouts_count': snapshot.workoutCount,
        'weight_kg': snapshot.weightKg,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to sync health: ${res.statusCode} ${res.body}');
    }
  }

  static Future<Map<String, dynamic>> getLeaderboard() async {
    final res = await http.get(
      Uri.parse('$baseUrl/leaderboard'),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get leaderboard: ${res.statusCode}');
  }

  static Future<Map<String, dynamic>> getStoreItems() async {
    final res = await http.get(
      Uri.parse('$baseUrl/store/items'),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get store: ${res.statusCode}');
  }

  static Future<void> buyItem(int itemId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/store/buy/$itemId'),
      headers: await _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to buy item: ${res.statusCode} ${res.body}');
    }
  }

  static Future<Map<String, dynamic>> getGuild() async {
    final res = await http.get(
      Uri.parse('$baseUrl/guild'),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get guild: ${res.statusCode}');
  }

  static Future<Map<String, dynamic>> getInventory() async {
    final res = await http.get(
      Uri.parse('$baseUrl/inventory'),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get inventory: ${res.statusCode}');
  }

  static Future<void> connectLyfta(String apiKey) async {
    final res = await http.post(
      Uri.parse('$baseUrl/lyfta/connect'),
      headers: await _headers,
      body: jsonEncode({'api_key': apiKey}),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to connect Lyfta: ${res.statusCode} ${res.body}');
    }
  }

  static Future<void> syncLyfta() async {
    final res = await http.post(
      Uri.parse('$baseUrl/lyfta/sync'),
      headers: await _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to sync Lyfta: ${res.statusCode} ${res.body}');
    }
  }
}
