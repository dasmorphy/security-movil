import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:zentinel/config/constants/environment.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ImagesGrid extends StatelessWidget {
  final String title;
  final List<dynamic> images;

  const ImagesGrid({
    super.key, 
    required this.title,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 16),

        Text(
          title,
          style: TextStyle(color: context.colors.textSecondary),
        ),

        const SizedBox(height: 8),

        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: images.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _openImageFullscreen(
                  context, images, index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'http://st.telearseg.net${images[index]}',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: context.colors.textPrimary.withOpacity(0.1),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.colors.textTertiary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, _, __) => Container(
                    color: context.colors.textPrimary.withOpacity(0.1),
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: context.colors.textTertiary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

   void _openImageFullscreen(
      BuildContext context, List<dynamic> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageViewer(images: images, initialIndex: initialIndex, baseUrl: Environments.baseUrl),
      ),
    );
  }
}