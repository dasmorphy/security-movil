import 'package:hive_flutter/hive_flutter.dart';
import 'package:zentinel/data/models/hive/user_profile_model.dart';
import 'package:zentinel/data/models/hive/user_session_model.dart';
import 'package:zentinel/domain/entities/user_session.dart';

class HiveService {
  static const String userProfileBox = 'user_profile';
  static const String userSessionBox = 'user_session';
  static const String sessionKey = 'current_session';

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserProfileModelAdapter());
    Hive.registerAdapter(UserSessionModelAdapter());
    
    // Crear cajas si no existen
    if (!Hive.isBoxOpen(userProfileBox)) {
      await Hive.openBox<UserProfileModel>(userProfileBox);
    }
    if (!Hive.isBoxOpen(userSessionBox)) {
      await Hive.openBox<UserSessionModel>(userSessionBox);
    }
  }

  // =============== PROFILE METHODS ===============
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

  // =============== SESSION METHODS ===============
  Future<void> saveUserSession(User user) async {
    final box = Hive.box<UserSessionModel>(userSessionBox);
    final sessionModel = UserSessionModel(
      userId: user.idUser,
      email: user.email,
      token: '', // El token se maneja en auth_provider
      role: user.role,
      attributes: user.attributes,
      user: user.user,
      isActive: user.isActive,
    );
    await box.put(sessionKey, sessionModel);
  }

  UserSessionModel? getUserSession() {
    final box = Hive.box<UserSessionModel>(userSessionBox);
    return box.get(sessionKey);
  }

  Future<void> deleteUserSession() async {
    final box = Hive.box<UserSessionModel>(userSessionBox);
    await box.delete(sessionKey);
  }

  bool hasUserSession() {
    final box = Hive.box<UserSessionModel>(userSessionBox);
    return box.containsKey(sessionKey);
  }

  Future<void> clearAllSessions() async {
    final box = Hive.box<UserSessionModel>(userSessionBox);
    await box.clear();
  }
}

