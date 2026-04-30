import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, String?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<String?> {
  late final SharedPreferences _perfs;
  @override
  Future<String?> build() async {
    _perfs = await SharedPreferences.getInstance();
    return _perfs.getString('token');
  }

  Future<void> login(String token) async {
    await _perfs.setString('token', token);
    state = AsyncData(token);
  }

  Future<void> logout() async {
    await _perfs.remove('token');
    state = AsyncData(null);
  }
}
