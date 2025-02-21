import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_app/animation_box.dart';
import 'package:flutter_3d_app/control_btn.dart';
import 'package:flutter_3d_app/loaded_model.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:file_picker/file_picker.dart';

class HomeScreen3d extends StatefulWidget {
  const HomeScreen3d({super.key});

  @override
  State<HomeScreen3d> createState() => _HomeScreen3dState();
}

class _HomeScreen3dState extends State<HomeScreen3d>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final Flutter3DController controller1 = Flutter3DController();
  final Flutter3DController controller2 = Flutter3DController();
  final Flutter3DController backgroundController = Flutter3DController();
  bool isRotating = false;
  bool isPlaying1 = false;
  bool isPlaying2 = false;
  double model1Rotation = -90;
  double model2Rotation = 90;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimation();
  }

  void _initializeControllers() {
    controller1.onModelLoaded.addListener(() {
      debugPrint('Model 1 Loaded! Adjusting Position');
      controller1.setCameraOrbit(-90, 110, 150);
    });

    controller2.onModelLoaded.addListener(() {
      debugPrint('Model 2 Loaded! Adjusting Position');
      controller2.setCameraOrbit(90, 110, 150);
    });
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animation.addListener(() {
      setState(() {
        model1Rotation = -90 + _animation.value;
        model2Rotation = 90 - _animation.value;
      });

      controller1.setCameraOrbit(model1Rotation, 110, 150);
      controller2.setCameraOrbit(model2Rotation, 110, 150);
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => isRotating = false);
      }
    });
  }

  //glb file picker functionality
  Future<void> pickAndLoadFile(BuildContext context) async {
    try {
      // open file picker for any file type
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Allow any file type
      );
      if (result == null || result.files.isEmpty) {
        debugPrint('File picking canceled or no file selected.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File picking canceled or no file selected.')),
        );
        return;
      }
      // get the file path
      String? filePath = result.files.single.path;
      debugPrint('Selected file path: $filePath'); // Debugging
      if (filePath == null) {
        debugPrint('Selected file has no valid path.');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Selected file is invalid.')));
        return;
      }
      // remove spaces
      filePath = filePath.replaceAll(' ', '');
      debugPrint('Processed file path: $filePath');
      // navigate to the LoadedModel
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadedModel(glbFilePath: filePath!),
        ),
      );
    } catch (e) {
      debugPrint('Error picking file: $e'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file. Please try again.')),
      );
    }
  }

  // function to toggle animation
  void toggleAnimation(Flutter3DController controller, int controllerNumber) {
    setState(() {
      if (controllerNumber == 1) {
        isPlaying1 = !isPlaying1;
      } else {
        isPlaying2 = !isPlaying2;
      }
    });

    if ((controllerNumber == 1 && isPlaying1) ||
        (controllerNumber == 2 && isPlaying2)) {
      controller.playAnimation();
    } else {
      controller.resetAnimation();
      controller.stopAnimation();
    }
  }

  // // function to rotate models

  void rotateModels() {
    if (isRotating) return;
    setState(() => isRotating = true);
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Viewer Demo', style: TextStyle(color: Colors.white)),
        //file picker button
        actions: [
          TextButton.icon(
            onPressed: () => pickAndLoadFile(context),
            label: Text('Load 3D file', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.upload_file, color: Colors.white),
          ),
        ],

        backgroundColor: Color(0xff000F24),
      ),
      backgroundColor: Color(0xff000F24),
      //  keyboard input
      body: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              toggleAnimation(controller1, 1);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              toggleAnimation(controller2, 2);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              rotateModels();
            }
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            //full screen
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  // Light background
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,

                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background/bg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // model one
                          Positioned(
                            left: 50,
                            bottom: 10,
                            child: AnimationBox(
                              controller: controller1,
                              glbFile: 'assets/models/fm.glb',
                            ),
                          ),
                          //model two
                          Positioned(
                            right: 50,
                            bottom: 10,
                            child: AnimationBox(
                              controller: controller2,
                              glbFile: 'assets/models/mm.glb',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //control buttons
                  Expanded(
                    flex: 1,
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //animation control buttons
                        ControlBtn(
                          activeIcon: Icons.stop,
                          inactiveIcon: Icons.play_arrow,
                          isActive: isPlaying1,
                          onTap: () => toggleAnimation(controller1, 1),
                        ),
                        ControlBtn(
                          activeIcon: Icons.stop,
                          inactiveIcon: Icons.play_arrow,
                          isActive: isPlaying2,
                          onTap: () => toggleAnimation(controller2, 2),
                        ),

                        //rotate controll button
                        ControlBtn(
                          activeIcon: Icons.refresh,
                          inactiveIcon: Icons.rotate_right,
                          isActive: isRotating,
                          onTap: rotateModels,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}















            // ControlBtn(
                      //   color: Colors.green,
                      //   icon: Icons.rotate_right,
                      //   onTap: () {
                      //     setState(() {
                      //       if (!isRotated) {
                      //         model1Rotation += -120;
                      //         model2Rotation += 120;
                      //       } else {
                      //         model1Rotation = -90;
                      //         model2Rotation = 90;
                      //       }
                      //       isRotated = !isRotated;
                      //     });

                      //     controller1.setCameraOrbit(model1Rotation, 110, 150);
                      //     controller2.setCameraOrbit(model2Rotation, 110, 150);
                      //   },
                      // ),










                             //floor container
                          // Positioned(
                          //   bottom: 50,
                          //   child: Container(
                          //     width: 300,
                          //     height: 10,
                          //     decoration: BoxDecoration(
                          //       color: Colors.grey.shade700,
                          //       borderRadius: BorderRadius.circular(10),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Color(0x66000000),
                          //           blurRadius: 15,
                          //           spreadRadius: 5,
                          //           offset: Offset(0, 10),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),



                              // gradient: LinearGradient(
                        //   begin: Alignment.topCenter,
                        //   end: Alignment.bottomCenter,
                        //   colors: [Colors.grey.shade300, Colors.grey.shade500],
                        // ),








                               // Expanded(
                  //   flex: 4,
                  //   child: SizedBox(
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Expanded(
                  //           child: AnimationBox(
                  //             controller: controller1,
                  //             glbFile: 'assets/models/fm.glb', // Model
                  //           ),
                  //         ),
                  //         Expanded(
                  //           child: AnimationBox(
                  //             controller: controller2,
                  //             glbFile: 'assets/models/mm.glb', // Mode2
                  //           ),
                  //         ),
                  //  ],
                  //     ),
                  //   ),
                  // ),