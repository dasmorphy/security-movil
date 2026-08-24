import 'package:hive_flutter/hive_flutter.dart';
import 'package:zentinel/data/models/hive/user_profile_model.dart';
import 'package:zentinel/data/models/hive/user_session_model.dart';
import 'package:zentinel/data/models/hive/category_model.dart';
import 'package:zentinel/data/models/hive/authorized_model.dart';
import 'package:zentinel/data/models/hive/destiny_intern_model.dart';
import 'package:zentinel/data/models/hive/unity_weight_model.dart';
import 'package:zentinel/data/models/hive/vehicle_type_model.dart';
import 'package:zentinel/data/models/hive/group_business_model.dart';
import 'package:zentinel/domain/entities/user_session.dart';

class HiveService {
  static const String userProfileBox = 'user_profile';
  static const String pendingRequestBox = 'pending_requests';
  static const String userSessionBox = 'user_session';
  static const String categoriesBox = 'categories';
  static const String authorizedBox = 'authorized';
  static const String destinyInternBox = 'destiny_intern';
  static const String unityWeightBox = 'unity_weight';
  static const String vehicleTypeBox = 'vehicle_type';
  static const String groupBusinessBox = 'group_business';
  static const String sessionKey = 'current_session';
  static const String pendingBiomar = 'pending_biomar';
  static const String registerTechnical = 'register_technical';
  static const String updateTechnical = 'update_technical';
  static const String pendingEmployeeMovements = 'pending_employee_movements';

  Future<void> initHive() async {
    await Hive.initFlutter();
    
    // Registrar adapters existentes
    Hive.registerAdapter(UserProfileModelAdapter());
    Hive.registerAdapter(UserSessionModelAdapter());
    
    // Registrar adapters para catálogos
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(AuthorizedModelAdapter());
    Hive.registerAdapter(DestinyInternModelAdapter());
    Hive.registerAdapter(UnityWeightModelAdapter());
    Hive.registerAdapter(VehicleTypeModelAdapter());
    Hive.registerAdapter(GroupBusinessModelAdapter());
    
    // Crear cajas si no existen
    if (!Hive.isBoxOpen(registerTechnical)) {
      await Hive.openBox(registerTechnical);
    }
    if (!Hive.isBoxOpen(updateTechnical)) {
      await Hive.openBox(updateTechnical);
    }
    if (!Hive.isBoxOpen(pendingRequestBox)) {
      await Hive.openBox(pendingRequestBox);
    }
    if (!Hive.isBoxOpen(pendingEmployeeMovements)) {
      await Hive.openBox(pendingEmployeeMovements);
    }
    if (!Hive.isBoxOpen(pendingBiomar)) {
      await Hive.openBox(pendingBiomar);
    }
    if (!Hive.isBoxOpen(userProfileBox)) {
      await Hive.openBox<UserProfileModel>(userProfileBox);
    }
    if (!Hive.isBoxOpen(userSessionBox)) {
      await Hive.openBox<UserSessionModel>(userSessionBox);
    }
    if (!Hive.isBoxOpen(categoriesBox)) {
      await Hive.openBox<CategoryModel>(categoriesBox);
    }
    if (!Hive.isBoxOpen(authorizedBox)) {
      await Hive.openBox<AuthorizedModel>(authorizedBox);
    }
    if (!Hive.isBoxOpen(destinyInternBox)) {
      await Hive.openBox<DestinyInternModel>(destinyInternBox);
    }
    if (!Hive.isBoxOpen(unityWeightBox)) {
      await Hive.openBox<UnityWeightModel>(unityWeightBox);
    }
    if (!Hive.isBoxOpen(vehicleTypeBox)) {
      await Hive.openBox<VehicleTypeModel>(vehicleTypeBox);
    }
    if (!Hive.isBoxOpen(groupBusinessBox)) {
      await Hive.openBox<GroupBusinessModel>(groupBusinessBox);
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
      token: user.attributes['accessToken'] ?? '', // Guardar el token JWT
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

  // =============== CATALOG METHODS ===============
  
  // CATEGORIES
  Future<void> saveCategories(List<CategoryModel> categories) async {
    final box = Hive.box<CategoryModel>(categoriesBox);
    await box.clear();
    for (var i = 0; i < categories.length; i++) {
      await box.put(i, categories[i]);
    }
  }

  List<CategoryModel> getCategories() {
    final box = Hive.box<CategoryModel>(categoriesBox);
    return box.values.toList();
  }

  bool hasCategories() {
    final box = Hive.box<CategoryModel>(categoriesBox);
    return box.isNotEmpty;
  }

  // AUTHORIZED
  Future<void> saveAuthorized(List<AuthorizedModel> authorized) async {
    final box = Hive.box<AuthorizedModel>(authorizedBox);
    await box.clear();
    for (var i = 0; i < authorized.length; i++) {
      await box.put(i, authorized[i]);
    }
  }

  List<AuthorizedModel> getAuthorized() {
    final box = Hive.box<AuthorizedModel>(authorizedBox);
    return box.values.toList();
  }

  bool hasAuthorized() {
    final box = Hive.box<AuthorizedModel>(authorizedBox);
    return box.isNotEmpty;
  }

  // DESTINY INTERN
  Future<void> saveDestinyIntern(List<DestinyInternModel> destinyIntern) async {
    final box = Hive.box<DestinyInternModel>(destinyInternBox);
    await box.clear();
    for (var i = 0; i < destinyIntern.length; i++) {
      await box.put(i, destinyIntern[i]);
    }
  }

  List<DestinyInternModel> getDestinyIntern() {
    final box = Hive.box<DestinyInternModel>(destinyInternBox);
    return box.values.toList();
  }

  bool hasDestinyIntern() {
    final box = Hive.box<DestinyInternModel>(destinyInternBox);
    return box.isNotEmpty;
  }

  // UNITY WEIGHT
  Future<void> saveUnityWeight(List<UnityWeightModel> unityWeight) async {
    final box = Hive.box<UnityWeightModel>(unityWeightBox);
    await box.clear();
    for (var i = 0; i < unityWeight.length; i++) {
      await box.put(i, unityWeight[i]);
    }
  }

  List<UnityWeightModel> getUnityWeight() {
    final box = Hive.box<UnityWeightModel>(unityWeightBox);
    return box.values.toList();
  }

  bool hasUnityWeight() {
    final box = Hive.box<UnityWeightModel>(unityWeightBox);
    return box.isNotEmpty;
  }

  // VEHICLE TYPE
  Future<void> saveVehicleType(List<VehicleTypeModel> vehicleType) async {
    final box = Hive.box<VehicleTypeModel>(vehicleTypeBox);
    await box.clear();
    for (var i = 0; i < vehicleType.length; i++) {
      await box.put(i, vehicleType[i]);
    }
  }

  List<VehicleTypeModel> getVehicleType() {
    final box = Hive.box<VehicleTypeModel>(vehicleTypeBox);
    return box.values.toList();
  }

  bool hasVehicleType() {
    final box = Hive.box<VehicleTypeModel>(vehicleTypeBox);
    return box.isNotEmpty;
  }

  // GROUP BUSINESS
  Future<void> saveGroupBusiness(List<GroupBusinessModel> groupBusiness) async {
    final box = Hive.box<GroupBusinessModel>(groupBusinessBox);
    await box.clear();
    for (var i = 0; i < groupBusiness.length; i++) {
      await box.put(i, groupBusiness[i]);
    }
  }

  List<GroupBusinessModel> getGroupBusiness() {
    final box = Hive.box<GroupBusinessModel>(groupBusinessBox);
    return box.values.toList();
  }

  bool hasGroupBusiness() {
    final box = Hive.box<GroupBusinessModel>(groupBusinessBox);
    return box.isNotEmpty;
  }
}

