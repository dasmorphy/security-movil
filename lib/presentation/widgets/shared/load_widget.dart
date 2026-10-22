import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class LoadWidget extends StatelessWidget {
  final String textLoad;
  const LoadWidget({super.key, this.textLoad = 'Cargando formulario...'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 280,
              child: Text(
                textLoad,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: context.colors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: context.colors.textPrimary,
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
