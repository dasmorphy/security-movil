import 'package:hive_flutter/hive_flutter.dart';
import 'package:zentinel/data/models/hive/user_profile_model.dart';

class HiveService {
  static const String userProfileBox = 'user_profile';

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserProfileModelAdapter());
    
    // Crear caja si no existe
    if (!Hive.isBoxOpen(userProfileBox)) {
      await Hive.openBox<UserProfileModel>(userProfileBox);
    }
  }

  Future<void> saveUserProfile(UserProfileModel profile) async {
    final box = Hive.box<UserProfileModel>(userProfileBox);
    await box.put(profile.email, profile);
  }

  UserProfileModel? getUserProfile(String email) {
    final box = Hive.box<UserProfileModel>(userProfileBox);
    return box.get(email);
  }

  bool hasUserProfile(String email) {
    final box = Hive.box<UserProfileModel>(userProfileBox);
    return box.containsKey(email);
  }

  Future<void> deleteUserProfile(String email) async {
    final box = Hive.box<UserProfileModel>(userProfileBox);
    await box.delete(email);
  }

  Future<void> clearAllProfiles() async {
    final box = Hive.box<UserProfileModel>(userProfileBox);
    await box.clear();
  }
}
