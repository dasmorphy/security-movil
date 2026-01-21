import 'package:flutter/material.dart';

class FavoritesCategorySection extends StatelessWidget {
  const FavoritesCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 80, 80, 80),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Estrella
          const Icon(
            Icons.star_rounded,
            size: 80,
            color: Color.fromARGB(255, 255, 205, 0),
          ),
          const SizedBox(height: 20),
          // Título
          Text(
            'Agrega tu primer favorito',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Subtítulo
          Text(
            'Elige tus servicios más frecuentes y guárdalos para acceder directamente',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color.fromARGB(255, 150, 150, 150),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
          // Botón Empezar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Acción del botón
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 145, 139),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Empezar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}