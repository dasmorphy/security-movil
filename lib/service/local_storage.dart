import 'package:hive_flutter/hive_flutter.dart';
import 'package:zentinel/data/models/hive/user_profile_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileModelAdapter());
  await Hive.openBox('pending_requests');
  await Hive.openBox<UserProfileModel>('user_profile');
}

Future<void> saveSession({
  required String name,
  required String photoPath,
}) async {
  final box = Hive.box('session');

  await box.put('name', name);
  await box.put('photo', photoPath);
}
