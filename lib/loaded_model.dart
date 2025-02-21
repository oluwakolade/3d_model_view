import 'package:flutter/material.dart';
import 'package:flutter_3d_app/animation_box.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class LoadedModel extends StatelessWidget {
  final String glbFilePath;

  const LoadedModel({super.key, required this.glbFilePath});

  @override
  Widget build(BuildContext context) {
    final Flutter3DController controller = Flutter3DController();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Center(
          child: Text(
            'Loaded 3D Viewer',
            style: TextStyle(color: Colors.white),
          ),
        ),

        backgroundColor: Color(0xff000F24),
      ),
      backgroundColor: Color(0xff000F24),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          //full screen
          child: Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              // animation box
              child: AnimationBox(controller: controller, glbFile: glbFilePath),
            ),
          ),
        ),
      ),
    );
  }
}
