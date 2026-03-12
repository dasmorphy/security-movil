import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends ConsumerState<ProfileView> {
  //SINO SE ESPECIFICA NOTIFIER DEVUELVE EL ESTADO POR DEFECTO, ES DECIR EL VALOR DE ESE PROVIDER

  @override
  void initState() {
    //En los metodos llmar el metodo read en los providers (flutter favorite)
    super.initState();
    // ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    // ref.read(popularMoviesProvider.notifier).loadNextPage();
    // ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    // ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(userSessionProvider);

    return authState.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (userData) {
        if (userData == null) {
          return const SizedBox();
        }

        // Obtener el perfil guardado en Hive
        final profileAsync = ref.watch(userProfileProvider(userData.email));

        return profileAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const SizedBox(),
          data: (userProfile) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const HeaderCategory(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Usuario Info
                        Center(
                          child: Column(
                            children: [
                              // Avatar con foto del onboarding
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                                child: userProfile != null &&
                                        userProfile.photoPath.isNotEmpty &&
                                        File(userProfile.photoPath).existsSync()
                                    ? ClipOval(
                                        child: Image.file(
                                          File(userProfile.photoPath),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          userProfile?.name
                                                  .isEmpty ??
                                              true
                                              ? 'D'
                                              : userProfile!.name[0]
                                                  .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 12),
                              // Nombre del onboarding
                              Text(
                                userProfile?.name ??
                                    userData.attributes['fullname'] ??
                                    'Usuario',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Última conexión
                              const Text(
                                'Última conexión: 22 ene. 2026 | 17:12',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // INFORMACIÓN PERSONAL
                        const Text(
                          'Información Personal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildMenuTile(
                          icon: Icons.person,
                          title: 'Datos personales',
                          onTap: () {
                            context.push('/personal-data');
                          },
                        ),
                        const SizedBox(height: 24),

                        // CONFIGURACIÓN
                        const Text(
                          'Configuración',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildMenuTile(
                          icon: Icons.security,
                          title: 'Seguridad',
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),

                        // EXPERIENCIA EN EL APP
                        const Text(
                          'Experiencia en el app',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildMenuTile(
                          icon: Icons.phonelink,
                          title: 'Servicios',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _buildMenuTile(
                          icon: Icons.phone,
                          title: 'Contáctanos',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _buildMenuTile(
                          icon: Icons.description,
                          title: 'Términos y condiciones',
                          onTap: () {
                            context.go('/personal-data');
                          },
                        ),
                        const SizedBox(height: 32),

                        // CERRAR SESIÓN
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Eliminar datos del onboarding
                              final hiveService =
                                  ref.read(hiveServiceProvider);
                              hiveService
                                  .deleteUserProfile(userData.email);

                              // Limpiar providers en caché
                              ref.invalidate(userProfileProvider);
                              ref.invalidate(userNameProvider);
                              
                              // Logout (elimina sesión de Hive)
                              await ref
                                  .read(userSessionProvider.notifier)
                                  .logout();
                              
                              ref.invalidate(userSessionProvider);
                              context.go('/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF4757),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 255, 255, 255),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
          ],
        ),
      ),
    );
  }
}
