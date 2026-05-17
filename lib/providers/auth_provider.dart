import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

final authProvider = AsyncNotifierProvider<AuthNotifier, String?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return await _storage.read(key: 'token');
  }

  Future<void> login(String token) async {
    await future;
    await _storage.write(key: 'token', value: token);
    state = AsyncData(token);
  }

  Future<void> logout() async {
    await future;
    await _storage.delete(key: 'token');
    state = AsyncData(null);
  }
}
