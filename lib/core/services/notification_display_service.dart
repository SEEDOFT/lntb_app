import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationDisplayService extends GetxService {
  static const _key = 'show_notifications_in_app';

  final isEnabled = true.obs;
  late final SharedPreferences _prefs;

  Future<NotificationDisplayService> init() async {
    _prefs = await SharedPreferences.getInstance();
    isEnabled.value = _prefs.getBool(_key) ?? true;
    return this;
  }

  Future<void> setEnabled({required bool value}) async {
    isEnabled.value = value;
    await _prefs.setBool(_key, value);
  }
}
