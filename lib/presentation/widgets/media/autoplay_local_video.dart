import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class VideoHeader extends StatefulWidget {
  const VideoHeader({super.key});

  @override
  State<VideoHeader> createState() => _VideoHeaderState();
}

class _VideoHeaderState extends State<VideoHeader> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/videos/obg.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.of(context).size.height * 0.26;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 🔹 VIDEO DE FONDO
            if (_controller.value.isInitialized)
              Positioned(
                top: 0, // 🔽 ajusta este valor
                left: 0,
                right: 0,
                bottom: -150, // opcional para compensar
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: 650,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),

        
            // 🔹 OVERLAY OSCURO
            Container(color: Colors.black.withOpacity(0.35)),
        
            //           Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   height: 20,
            //   child: Container(
            //     color: Colors.black.withOpacity(0.25),
            //   ),
            // ),
        
            // 🔹 CONTENIDO DEL HEADER
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'lib/assets/images/zentinel-logo.png',
                          width: 145,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                    
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                // context.go('/splash');
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(7),
                                child: Icon(Icons.search, color: Colors.white),
                              ),
                            ),
                                
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                // context.go('/check-success');
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(7),
                                child: Icon(Icons.help_outline, color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                    
                    const SizedBox(height: 13,),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hola,',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                          const Text(
                            'Daniel',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
