import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quest.dart';
import '../models/stats.dart';
import 'auth_service.dart';
import '../config.dart';
import 'health_connect_service.dart';

class ApiService {
  static String get baseUrl {
    if (BuildConfig.baseUrl.isNotEmpty) return BuildConfig.baseUrl;
    if (BuildConfig.apiHost.isNotEmpty && BuildConfig.apiPort.isNotEmpty) {
      return 'http://${BuildConfig.apiHost}:${BuildConfig.apiPort}/api/v1';
    }
    return 'http://10.0.2.2:8004/api/v1';
  }

  static String get _rootUrl => baseUrl.replaceFirst('/api/v1', '');

  static const _defaultTimeout = Duration(seconds: 10);

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
    ).timeout(_defaultTimeout);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      // /users/me returns nested FullProfile {user, stats, ...}
      // Unwrap to flat map for backward compatibility
      if (data is Map<String, dynamic> && data.containsKey('user')) {
        final user = Map<String, dynamic>.from(data['user']);
        user['stats'] = data['stats'];
        user['titles'] = data['titles'];
        user['inventory_count'] = data['inventory_count'];
        user['guild_id'] = data['guild_id'];
        return user;
      }
      return data;
    }
    throw Exception('Failed to get user: ${res.statusCode}');
  }

  static Future<PlayerStats> getStats() async {
    final res = await http.get(
      Uri.parse('$baseUrl/stats'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode == 200) {
      return PlayerStats.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to get stats: ${res.statusCode}');
  }

  static Future<bool> ping() async {
    try {
      final res = await http.get(Uri.parse('$_rootUrl/health'))
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/auth/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'username=${Uri.encodeQueryComponent(username)}&password=${Uri.encodeQueryComponent(password)}',
    ).timeout(_defaultTimeout);
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data.containsKey('access_token')) {
      await AuthService.saveToken(data['access_token']);
    }
    return data;
  }

  static Future<Map<String, dynamic>> register(
      String email, String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    ).timeout(_defaultTimeout);
    return jsonDecode(res.body);
  }

  static Future<List<Quest>> getQuests({String? type}) async {
    var url = '$baseUrl/quests';
    if (type != null) url += '?type=$type';
    final res = await http.get(
      Uri.parse(url),
      headers: await _headers,
    ).timeout(_defaultTimeout);
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
      Uri.parse('$baseUrl/quests/check-completion'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['completed_quests'] as List).map((q) => Quest.fromJson(q)).toList();
    }
    if (res.statusCode == 404) return [];
    throw Exception('Failed to check quests: ${res.statusCode}');
  }

  static Future<void> completeQuest(int questId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/quests/$questId/complete'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
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
    ).timeout(_defaultTimeout);
    if (res.statusCode != 200) {
      throw Exception('Failed to sync health: ${res.statusCode} ${res.body}');
    }
  }

  static Future<Map<String, dynamic>> getLeaderboard() async {
    final res = await http.get(
      Uri.parse('$baseUrl/stats/leaderboard'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get leaderboard: ${res.statusCode}');
  }

  static Future<Map<String, dynamic>> getStoreItems() async {
    final res = await http.get(
      Uri.parse('$baseUrl/store/items'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get store: ${res.statusCode}');
  }

  static Future<void> buyItem(int itemId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/store/buy/$itemId'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode != 200) {
      throw Exception('Failed to buy item: ${res.statusCode} ${res.body}');
    }
  }

  static Future<Map<String, dynamic>> getGuild() async {
    final res = await http.get(
      Uri.parse('$baseUrl/guilds/'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get guild: ${res.statusCode}');
  }

  static Future<Map<String, dynamic>> getInventory() async {
    final res = await http.get(
      Uri.parse('$baseUrl/inventory'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get inventory: ${res.statusCode}');
  }

  static Future<void> useItem(int itemId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/inventory/use/$itemId'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode != 200) {
      throw Exception('Failed to use item: ${res.statusCode} ${res.body}');
    }
  }

  static Future<void> equipItem(int itemId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/inventory/equip/$itemId'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode != 200) {
      throw Exception('Failed to equip item: ${res.statusCode} ${res.body}');
    }
  }

  static Future<void> joinGuild(int guildId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/guilds/$guildId/join'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode != 200) {
      throw Exception('Failed to join guild: ${res.statusCode} ${res.body}');
    }
  }

  static Future<void> createGuild(String name, String description) async {
    final res = await http.post(
      Uri.parse('$baseUrl/guilds/'),
      headers: await _headers,
      body: jsonEncode({'name': name, 'description': description}),
    ).timeout(_defaultTimeout);
    if (res.statusCode != 200) {
      throw Exception('Failed to create guild: ${res.statusCode} ${res.body}');
    }
  }

  static Future<void> connectLyfta(String apiKey) async {
    final res = await http.post(
      Uri.parse('$baseUrl/integrations/lyfta/connect'),
      headers: await _headers,
      body: jsonEncode({'api_key': apiKey}),
    ).timeout(_defaultTimeout);
    if (res.statusCode != 200) {
      throw Exception('Failed to connect Lyfta: ${res.statusCode} ${res.body}');
    }
  }

  static Future<void> syncLyfta() async {
    final res = await http.post(
      Uri.parse('$baseUrl/integrations/lyfta/sync'),
      headers: await _headers,
    ).timeout(_defaultTimeout);
    if (res.statusCode != 200) {
      throw Exception('Failed to sync Lyfta: ${res.statusCode} ${res.body}');
    }
  }

  static Future<void> allocateStats({
    int str = 0,
    int agi = 0,
    int vit = 0,
    int int_ = 0,
    int sen = 0,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/me/allocate-stats'),
      headers: await _headers,
      body: jsonEncode({
        'str_points': str,
        'agi_points': agi,
        'vit_points': vit,
        'int_points': int_,
        'sen_points': sen,
      }),
    ).timeout(_defaultTimeout);
    if (res.statusCode != 200) {
      throw Exception('Failed to allocate stats: ${res.statusCode} ${res.body}');
    }
  }
}
