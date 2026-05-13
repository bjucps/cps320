import 'package:shared_preferences/shared_preferences.dart';

class LocalFavorites {
  static const String key = "favorite_events";

  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    return list.toSet();
  }

  Future<void> saveFavorites(Set<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, favorites.toList());
  }
}
