import 'api_service.dart';
import 'settings_service.dart';

class LyftaService {
  static Future<void> connect(String apiKey) async {
    await ApiService.connectLyfta(apiKey);
    await SettingsService.instance.setLyftaConnected(true);
  }

  static Future<void> sync() async {
    await ApiService.syncLyfta();
  }
}
