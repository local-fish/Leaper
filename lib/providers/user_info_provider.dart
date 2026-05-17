import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  int userId;
  String name;
  String role;
  String email;

  UserInfo({
    required this.userId,
    required this.name,
    required this.role,
    required this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    userId: json['id'],
    name: json['name'],
    role: json['role'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'id': userId,
    'name': name,
    'role': role,
    'email': email,
  };
}

final userInfoProvider = AsyncNotifierProvider<UserInfoNotifier, UserInfo?>(
  UserInfoNotifier.new,
);

class UserInfoNotifier extends AsyncNotifier<UserInfo?> {
  late final SharedPreferences _perfs;
  @override
  Future<UserInfo?> build() async {
    _perfs = await SharedPreferences.getInstance();
    final raw = _perfs.getString('user');
    if (raw != null) {
      return UserInfo.fromJson(jsonDecode(raw));
    } else {
      return null;
    }
  }

  Future<void> login(UserInfo item) async {
    await future;
    await _perfs.setString('user', jsonEncode(item.toJson()));
    state = AsyncData(item);
  }

  Future<void> logout() async {
    await future;
    await _perfs.remove('user');
    state = AsyncData(null);
  }
}
