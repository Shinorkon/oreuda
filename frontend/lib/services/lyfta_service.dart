import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

/// Lyfta gym workout tracker integration service.
/// Connects to the OREUDA backend which handles Lyfta API communication.
class LyftaService {
  static const String _lastSyncKey = 'lyfta_last_sync';

  /// Connect a Lyfta API key to the user's account.
  static Future<bool> connect(String apiKey) async {
    final res = await ApiService.post(
      '/integrations/lyfta/connect',
      body: {'api_key': apiKey},
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('lyfta_connected', true);
      return true;
    }
    throw Exception(data['detail'] ?? 'Failed to connect Lyfta');
  }

  /// Sync workouts from Lyfta.
  static Future<Map<String, dynamic>> sync() async {
    final res = await ApiService.post('/integrations/lyfta/sync');
    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
      return data;
    }
    throw Exception(data['detail'] ?? 'Sync failed');
  }

  /// Get Lyfta connection status.
  static Future<Map<String, dynamic>> getStatus() async {
    final res = await ApiService.get('/integrations/lyfta/status');
    return jsonDecode(res.body);
  }

  /// Disconnect Lyfta.
  static Future<bool> disconnect({bool deleteData = false}) async {
    final token = await ApiService._headers();
    final uri = Uri.parse(
      '${ApiService.baseUrl}/integrations/lyfta/disconnect?delete_data=$deleteData',
    );
    final res = await http.delete(uri, headers: token);
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('lyfta_connected', false);
      await prefs.remove(_lastSyncKey);
      return true;
    }
    throw Exception(data['detail'] ?? 'Disconnect failed');
  }

  /// Get human-readable last sync time.
  static Future<String?> getLastSyncText() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_lastSyncKey);
    if (ms == null) return null;
    final lastSync = DateTime.fromMillisecondsSinceEpoch(ms);
    final diff = DateTime.now().difference(lastSync);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  /// Check if auto-sync is due (every 6 hours).
  static Future<bool> isSyncDue() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_lastSyncKey);
    if (ms == null) return true;
    final lastSync = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateTime.now().difference(lastSync).inHours >= 6;
  }
}
