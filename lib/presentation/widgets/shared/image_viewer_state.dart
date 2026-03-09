import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final List<dynamic> images;
  final int initialIndex;
  final String baseUrl;

  const ImageViewer({super.key, required this.images, required this.initialIndex, required this.baseUrl});

  @override
  State<ImageViewer> createState() => ImageViewerState();
}

class ImageViewerState extends State<ImageViewer> {
  late final PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_current + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (context, index) => InteractiveViewer(
          child: Center(
            child: Image.network(
              'http://st.telearseg.net${widget.images[index]}',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.white30,
                size: 64,
              ),
            ),
          ),
        ),
      ),
    );
  }
}