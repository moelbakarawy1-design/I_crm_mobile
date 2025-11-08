import 'dart:async';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/featuer/chat/view/pages/PreviewScreen_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  bool _noCameraFound = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupCameras();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(_cameras[_selectedCameraIndex]);
    }
  }

  Future<void> _setupCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) setState(() => _noCameraFound = true);
        return;
      }
      // Initialize with the first camera (usually back)
      await _initializeCamera(_cameras[_selectedCameraIndex]);
    } on CameraException catch (e) {
      print("Error setting up cameras: ${e.code}: ${e.description}");
      if (mounted) setState(() => _noCameraFound = true);
    }
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false, 
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } on CameraException catch (e) {
      print("Error initializing camera: ${e.code}: ${e.description}");
      if (mounted) setState(() => _noCameraFound = true);
    }
  }

  Future<void> _onTakePicturePressed() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture) {
      return;
    }

    try {

      final XFile file = await _controller!.takePicture();

      print('Picture saved to: ${file.path}');

 
     
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => PreviewScreen(imagePath: file.path),
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Picture saved to: ${file.path}')),
      );
    } on CameraException catch (e) {
      print("Error taking picture: ${e.code}: ${e.description}");
    }
  }

  void _onSwitchCameraPressed() {
    if (_cameras.length < 2) return; 

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;

    _initializeCamera(_cameras[_selectedCameraIndex]);
  }

  @override
  Widget build(BuildContext context) {
    if (_noCameraFound) {
      return const Center(
        child: Text(
          'No camera found.\nPlease check app permissions.',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          _buildControlsOverlay(),
        ],
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.black.withOpacity(0.5),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _onSwitchCameraPressed,
                icon: Icon(
                  Icons.flip_camera_ios_outlined,
                  color: AppColor.mainWhite,
                  size: 30.sp,
                ),
              ),
              GestureDetector(
                onTap: _onTakePicturePressed,
                child: Container(
                  width: 70.r,
                  height: 70.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.mainWhite,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2.w),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 48.w), 
            ],
          ),
        ),
      ],
    );
  }
}