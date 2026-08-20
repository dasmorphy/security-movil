import 'package:flutter/material.dart';
import 'package:zentinel/config/constants/environment.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ImagesGrid extends StatelessWidget {
  final String title;
  final String? urlNetwork;
  final List<dynamic> images;

  const ImagesGrid({
    super.key, 
    required this.title,
    required this.images,
    this.urlNetwork,
  });

  @override
  Widget build(BuildContext context) {
    final baseUrl = urlNetwork ?? Environments.baseUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 16),

        Text(
          title,
          style: const TextStyle(color: Colors.white70),
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
                  context, images, index, baseUrl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  '$baseUrl${images[index]}',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.white10,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white54,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, _, __) => Container(
                    color: Colors.white10,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white30,
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

   void _openImageFullscreen(BuildContext context, List<dynamic> images, int initialIndex, String baseUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageViewer(images: images, initialIndex: initialIndex, baseUrl: baseUrl),
      ),
    );
  }
}