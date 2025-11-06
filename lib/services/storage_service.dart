import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

/// Service for secure local storage
class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Save GitHub token
  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConfig.tokenKey, value: token);
  }

  /// Get GitHub token
  Future<String?> getToken() async {
    return await _storage.read(key: AppConfig.tokenKey);
  }

  /// Save GitHub username
  Future<void> saveUsername(String username) async {
    await _storage.write(key: AppConfig.usernameKey, value: username);
  }

  /// Get GitHub username
  Future<String?> getUsername() async {
    return await _storage.read(key: AppConfig.usernameKey);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final username = await getUsername();
    return token != null && username != null;
  }

  /// Clear all stored data (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
