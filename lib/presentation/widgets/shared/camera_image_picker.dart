import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zentinel/config/utils/helper.dart';

class CameraImagePicker extends StatefulWidget {
  final int minImages;
  final int maxImages;
  final Function(List<Uint8List>) onImagesChanged;

  const CameraImagePicker({
    super.key,
    this.minImages = 0,
    this.maxImages = 10,
    required this.onImagesChanged,
  });

  @override
  State<CameraImagePicker> createState() => _CameraImagePickerState();
}

class _CameraImagePickerState extends State<CameraImagePicker> {
  final ImagePicker _imagePicker = ImagePicker();

  final List<Uint8List?> _selectedImages = [];

  bool imagesMinError = false;
  bool imagesMaxError = false;

  @override
  Widget build(BuildContext context) {
    Future<void> captureImageFromCamera() async {
      if (_selectedImages.length >= widget.maxImages) {
        setState(() => imagesMaxError = true);
        return;
      }

      try {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 60,
          maxWidth: 1024,
          maxHeight: 1024,
        );

        if (image == null) return;

        setState(() {
          _selectedImages.add(null);
          imagesMinError = false;
          imagesMaxError = false;
        });

        final index = _selectedImages.length - 1;

        final file = File(image.path);

        final webpFile = await convertToWebP(file);

        if (!mounted) return;

        if (webpFile == null) {
          setState(() => _selectedImages.removeAt(index));
          return;
        }
        print(
          "Peso WebP: ${(webpFile.length / 1024 / 1024).toStringAsFixed(2)} MB",
        );

        setState(() {
          _selectedImages[index] = webpFile;
        });

        widget.onImagesChanged(_selectedImages.whereType<Uint8List>().toList());
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    void removeImage(int index) {
      setState(() {
        _selectedImages.removeAt(index);
      });

      widget.onImagesChanged(_selectedImages.whereType<Uint8List>().toList());
    }

    return Column(
      children: [
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //     onPressed: captureImageFromCamera,
        //     icon: const Icon(
        //       Icons.camera_alt,
        //       color: Color.fromARGB(189, 7, 213, 213),
        //     ),
        //     label: const Text(
        //       'Capturar Imagen',
        //       style: TextStyle(color: Color.fromARGB(189, 7, 213, 213)),
        //     ),
        //     style: OutlinedButton.styleFrom(
        //       side: const BorderSide(color: Color.fromARGB(189, 7, 213, 213)),
        //       padding: const EdgeInsets.symmetric(vertical: 12),
        //     ),
        //   ),
        // ),
        GestureDetector(
          onTap: () => captureImageFromCamera(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 40, 40, 45),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(255, 75, 83, 83),
                width: 1.5,
                style: BorderStyle.solid,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: Color.fromARGB(255, 150, 150, 150),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Adjuntar Evidencia Fotográfica',
                  style: TextStyle(
                    color: Color.fromARGB(255, 150, 150, 150),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        _selectedImages.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _selectedImages.length,
                itemBuilder: (_, index) {
                  final image = _selectedImages[index];

                  return Stack(
                    children: [
                      // Mostrar indicador de progreso cuando la imagen está siendo convertida (placeholder null)
                      image != null
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: MemoryImage(
                                    image,
                                  ), // directo desde bytes
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black26,
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      Positioned(
                        top: -8,
                        right: -8,
                        child: IconButton(
                          onPressed: () => removeImage(index),
                          icon: const Icon(Icons.close, color: Colors.red),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            iconSize: 16,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No hay imágenes capturadas',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),

        if (imagesMinError || imagesMaxError)
          SizedBox(
            width: double.infinity,
            child: Text(
              imagesMinError
                  ? 'Debe subir mínimo 5 imagenes'
                  : 'Debe subir máximo 10 imagenes',
              style: TextStyle(color: Color.fromARGB(255, 185, 28, 16)),
            ),
          ),
      ],
    );
  }
}
