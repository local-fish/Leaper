import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userInfoProvider = AsyncNotifierProvider<UserInfoNotifier, String?>(
  UserInfoNotifier.new,
);

class UserInfoNotifier extends AsyncNotifier<String?> {
  late final SharedPreferences _perfs;
  @override
  Future<String?> build() async {
    _perfs = await SharedPreferences.getInstance();
    return _perfs.getString('name');
  }

  Future<void> login(String name) async {
    await future;
    await _perfs.setString('name', name);
    state = AsyncData(name);
  }

  Future<void> logout() async {
    await future;
    await _perfs.remove('name');
    state = AsyncData(null);
  }
}
