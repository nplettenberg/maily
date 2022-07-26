import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => throw UnimplementedError('Should be initialized before using app'),
);

final storageProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('Should be initialized before using app'),
);
