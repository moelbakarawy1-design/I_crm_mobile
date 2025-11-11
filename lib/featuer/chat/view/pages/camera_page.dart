import 'dart:async';
import 'package:admin_app/featuer/chat/view/pages/PreviewScreen_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
  double _currentZoomLevel = 1.0;
  double _maxZoom = 1.0;
  double _minZoom = 1.0;
  Offset? _focusPoint;
  bool _isTakingPicture = false;

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
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed && _cameras.isNotEmpty) {
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
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      _maxZoom = await _controller!.getMaxZoomLevel();
      _minZoom = await _controller!.getMinZoomLevel();
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
        _controller!.value.isTakingPicture ||
        _isTakingPicture) {
      return;
    }

    try {
      setState(() => _isTakingPicture = true);
      final XFile file = await _controller!.takePicture();

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: file.path),
        ),
      );

      setState(() => _isTakingPicture = false);
    } on CameraException catch (e) {
      print("Error taking picture: ${e.code}: ${e.description}");
      setState(() => _isTakingPicture = false);
    }
  }

  void _onSwitchCameraPressed() {
    if (_cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _initializeCamera(_cameras[_selectedCameraIndex]);
  }

  void _onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (_controller == null) return;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );

    _controller!.setFocusPoint(offset);
    setState(() => _focusPoint = details.localPosition);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _focusPoint = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_noCameraFound) {
      return const Scaffold(
        body: Center(
          child: Text('No camera found.\nPlease check permissions.'),
        ),
      );
    }

    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onScaleUpdate: (details) async {
          final zoom = (_currentZoomLevel * details.scale)
              .clamp(_minZoom, _maxZoom);
          _currentZoomLevel = zoom;
          await _controller!.setZoomLevel(zoom);
        },
        onHorizontalDragEnd: (details) {
          _onSwitchCameraPressed(); // swipe to switch camera
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) =>
                      _onViewFinderTap(details, constraints),
                  child: CameraPreview(_controller!),
                );
              },
            ),
            if (_focusPoint != null)
              Positioned(
                left: _focusPoint!.dx - 20,
                top: _focusPoint!.dy - 20,
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.yellow,
                        width: 2,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
              ),
            _buildOverlayControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayControls() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top bar (close and flash icons)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.close, color: Colors.white, size: 28.sp),
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                  onPressed: _onSwitchCameraPressed,
                ),
              ],
            ),
          ),

          // Bottom bar (capture)
          Padding(
            padding: EdgeInsets.only(bottom: 30.h),
            child: GestureDetector(
              onTap: _onTakePicturePressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isTakingPicture ? 80.r : 70.r,
                height: _isTakingPicture ? 80.r : 70.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 5.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
