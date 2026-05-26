import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final apiProvider = AsyncNotifierProvider<ApiNotifier, String?>(
  ApiNotifier.new,
);

class ApiNotifier extends AsyncNotifier<String?> {
  late final SharedPreferences _perfs;
  @override
  Future<String?> build() async {
    _perfs = await SharedPreferences.getInstance();
    return _perfs.getString('endpoint');
  }

  Future<void> login(String item) async {
    await future;
    await _perfs.setString('endpoint', item);
    state = AsyncData(item);
  }

  Future<void> logout() async {
    await future;
    await _perfs.remove('endpoint');
    state = AsyncData(null);
  }
}
