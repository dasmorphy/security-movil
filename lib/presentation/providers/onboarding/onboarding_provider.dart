import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/data/services/hive_service.dart';
import 'package:zentinel/data/models/hive/user_profile_model.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

final userNameProvider = StateProvider<String>((ref) => '');

// Provider para obtener el perfil guardado en Hive
final userProfileProvider =
    FutureProvider.family<UserProfileModel?, String>((ref, email) async {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.getUserProfile(email);
});

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<void>>((ref) {
  return OnboardingNotifier(
    hiveService: ref.watch(hiveServiceProvider),
    ref: ref,
  );
});

class OnboardingNotifier extends StateNotifier<AsyncValue<void>> {
  final HiveService hiveService;
  final Ref ref;

  OnboardingNotifier({
    required this.hiveService,
    required this.ref,
  }) : super(const AsyncValue.data(null));

  Future<void> saveUserProfile({required String photoPath}) async {
    state = const AsyncValue.loading();

    try {
      final userSession = ref.read(userSessionProvider);

      final userData = userSession.maybeWhen(
        data: (user) => user,
        orElse: () => null,
      );

      if (userData == null) {
        throw Exception('Usuario no autenticado');
      }

      final userName = ref.read(userNameProvider);

      if (userName.isEmpty) {
        throw Exception('El nombre no fue configurado');
      }

      final profile = UserProfileModel(
        email: userData.email,
        name: userName,
        photoPath: photoPath,
        createdAt: DateTime.now(),
      );

      await hiveService.saveUserProfile(profile);
      
      // Invalidar el provider para que se refresque desde Hive
      ref.invalidate(userProfileProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}
