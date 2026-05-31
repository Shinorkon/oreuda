import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  /// Override host for physical devices: `flutter run --dart-define=API_HOST=192.168.1.5`
  static const String _apiHost = String.fromEnvironment('API_HOST');
  static const Duration _timeout = Duration(seconds: 15);

  /// Android emulator: 10.0.2.2 → host localhost. Linux/macOS/iOS/web: 127.0.0.1.
  static String get baseUrl {
    final host = _apiHost.isNotEmpty
        ? _apiHost
        : (kIsWeb
            ? '127.0.0.1'
            : Platform.isAndroid
                ? '10.0.2.2'
                : '127.0.0.1');
    return 'http://$host:8000/api/v1';
  }

  /// Quick check that the API is reachable (no auth required).
  static Future<bool> ping() async {
    try {
      final host = _apiHost.isNotEmpty
          ? _apiHost
          : (kIsWeb
              ? '127.0.0.1'
              : Platform.isAndroid
                  ? '10.0.2.2'
                  : '127.0.0.1');
      final res = await _withTimeout(
        http.get(Uri.parse('http://$host:8000/health')),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> _withTimeout(Future<http.Response> request) =>
      request.timeout(_timeout);

  static Future<http.Response> get(String path) async {
    final headers = await _headers();
    return _withTimeout(
      http.get(Uri.parse('$baseUrl$path'), headers: headers),
    );
  }

  static Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
    final headers = await _headers();
    return _withTimeout(
      http.post(
        Uri.parse('$baseUrl$path'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  static Future<http.Response> put(String path, {Map<String, dynamic>? body}) async {
    final headers = await _headers();
    return _withTimeout(
      http.put(
        Uri.parse('$baseUrl$path'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  static Map<String, dynamic> _decodeJson(http.Response res) {
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'detail': res.body};
    } catch (_) {
      return {'detail': 'Invalid server response (${res.statusCode})'};
    }
  }

  // Auth
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await post('/users/login', body: {
      'username': username,
      'password': password,
    });
    final data = _decodeJson(res);
    if (res.statusCode == 200 && data['access_token'] != null) {
      await AuthService.saveToken(data['access_token'] as String);
    }
    return data;
  }

  static Future<Map<String, dynamic>> register(String email, String username, String password) async {
    final res = await post('/users/register', body: {
      'email': email,
      'username': username,
      'password': password,
      'display_name': username,
    });
    return _decodeJson(res);
  }

  // User
  static Future<Map<String, dynamic>> getMe() async {
    final res = await get('/users/me');
    return _decodeJson(res);
  }

  // Quests
  static Future<List<dynamic>> getQuests({String? type, String? status}) async {
    var path = '/quests/';
    final params = <String>[];
    if (type != null) params.add('quest_type=$type');
    if (status != null) params.add('status=$status');
    if (params.isNotEmpty) path += '?${params.join('&')}';
    final res = await get(path);
    final decoded = jsonDecode(res.body);
    if (decoded is List) return decoded;
    throw Exception(decoded is Map ? decoded['detail'] : 'Failed to load quests');
  }

  static Future<List<dynamic>> getDailyQuests() async {
    final res = await get('/quests/daily');
    final decoded = jsonDecode(res.body);
    if (decoded is List) return decoded;
    throw Exception(decoded is Map ? decoded['detail'] : 'Failed to load daily quests');
  }

  static Future<Map<String, dynamic>> completeQuest(int questId) async {
    final res = await post('/quests/$questId/complete');
    return _decodeJson(res);
  }

  static Future<Map<String, dynamic>> failQuest(int questId) async {
    final res = await post('/quests/$questId/fail');
    return _decodeJson(res);
  }

  // Stats
  static Future<Map<String, dynamic>> getStats() async {
    final res = await get('/stats/');
    return _decodeJson(res);
  }

  static Future<List<dynamic>> getLeaderboard() async {
    final res = await get('/stats/leaderboard');
    final decoded = jsonDecode(res.body);
    if (decoded is List) return decoded;
    throw Exception('Failed to load leaderboard');
  }

  // Inventory
  static Future<List<dynamic>> getInventory() async {
    final res = await get('/inventory/');
    final decoded = jsonDecode(res.body);
    if (decoded is List) return decoded;
    throw Exception('Failed to load inventory');
  }

  // Store
  static Future<List<dynamic>> getStoreItems() async {
    final res = await get('/store/items');
    final decoded = jsonDecode(res.body);
    if (decoded is List) return decoded;
    throw Exception('Failed to load store');
  }

  static Future<Map<String, dynamic>> buyItem(int itemId) async {
    final res = await post('/store/buy/$itemId');
    return _decodeJson(res);
  }

  // Guilds
  static Future<List<dynamic>> getGuilds() async {
    final res = await get('/guilds/');
    final decoded = jsonDecode(res.body);
    if (decoded is List) return decoded;
    throw Exception('Failed to load guilds');
  }
}
