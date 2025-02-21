import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class AnimationBox extends StatelessWidget {
  final String glbFile;
  final Flutter3DController controller;
  final double rotationY;
  final double scale;

  const AnimationBox({
    super.key,
    required this.glbFile,
    required this.controller,
    this.rotationY = 0,
    this.scale = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 170,
      //scale 3d model
      child: Transform(
        alignment: Alignment.center,
        transform:
            Matrix4.identity()
              ..rotateY(rotationY)
              ..scale(scale),
        // load 3d model
        child: Flutter3DViewer(
          controller: controller,
          src: glbFile,
          progressBarColor: Colors.green,
        ),
      ),
    );
  }
}
