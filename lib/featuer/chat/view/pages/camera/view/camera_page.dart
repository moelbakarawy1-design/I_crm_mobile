import 'dart:async';
import 'package:admin_app/featuer/chat/view/pages/camera/view/PreviewScreen_page.dart';
import 'package:admin_app/featuer/chat/view/pages/camera/Widget/camera_overlay_ui.dart';
import 'package:admin_app/featuer/chat/view/pages/camera/Widget/camera_preview_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  // --- State Variables ---
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
  
  final GlobalKey _previewKey = GlobalKey();

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

  // --- Logic Functions ---

  Future<void> _setupCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) setState(() => _noCameraFound = true);
        return;
      }
      await _initializeCamera(_cameras[_selectedCameraIndex]);
    } on CameraException catch (e) {
      debugPrint("Error: $e");
      if (mounted) setState(() => _noCameraFound = true);
    }
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    final prevController = _controller;
    final newController = CameraController(
      cameraDescription,
      ResolutionPreset.high, // جودة عالية
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    if (prevController != null) {
      await prevController.dispose();
    }

    try {
      _controller = newController;
      await _controller!.initialize();
      _maxZoom = await _controller!.getMaxZoomLevel();
      _minZoom = await _controller!.getMinZoomLevel();
      if (mounted) setState(() => _isCameraInitialized = true);
    } on CameraException catch (e) {
      debugPrint("Error initializing: $e");
    }
  }

  Future<void> _onTakePicturePressed() async {
    if (_controller == null || !_controller!.value.isInitialized || _isTakingPicture) return;

    try {
      setState(() => _isTakingPicture = true);
      final XFile file = await _controller!.takePicture();

      if (!mounted) return;

      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewScreen(imagePath: file.path)),
      );

      if (result != null && result is Map && mounted) {
        Navigator.pop(context, result);
      }
      
      if (mounted) setState(() => _isTakingPicture = false);
    } catch (e) {
      debugPrint("Error capturing: $e");
      if (mounted) setState(() => _isTakingPicture = false);
    }
  }

  void _onSwitchCameraPressed() {
    if (_cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _initializeCamera(_cameras[_selectedCameraIndex]);
  }

 void _onViewFinderTap(TapDownDetails details) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final RenderBox? box = _previewKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final offset = Offset(
      details.localPosition.dx / box.size.width,
      details.localPosition.dy / box.size.height,
    );

    try {
      await _controller!.setFocusPoint(offset);
    } on CameraException catch (e) {
      debugPrint("❌ Focus not supported on this device: ${e.description}");
      return; 
    }
    if (mounted) {
      setState(() => _focusPoint = details.localPosition);
    }
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _focusPoint = null);
      }
    });
  }
  // Build Method 
  @override
  Widget build(BuildContext context) {
    if (_noCameraFound) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: Text('No camera found', style: TextStyle(color: Colors.white))));
    }
    if (!_isCameraInitialized || _controller == null) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
    
        onScaleUpdate: (details) async {
          final zoom = (_currentZoomLevel * details.scale).clamp(_minZoom, _maxZoom);
          _currentZoomLevel = zoom;
          await _controller!.setZoomLevel(zoom);
        },
        // Switch Camera Swipe
        onHorizontalDragEnd: (_) => _onSwitchCameraPressed(),        
        child: Stack(
          fit: StackFit.expand,
          children: [
            //  Full Screen Camera
            GestureDetector(
              onTapDown: _onViewFinderTap,
              child: Container(
                key: _previewKey,
                child: FullScreenCameraPreview(controller: _controller!),
              ),
            ),
            //  Overlay Controls (Focus & Buttons)         
          CameraOverlayUI(
              isTakingPicture: _isTakingPicture,
              focusPoint: _focusPoint,
              onClose: () => Navigator.pop(context),
              onSwitchCamera: _onSwitchCameraPressed,
              onCapture: _onTakePicturePressed,
            ),
          ],
        ),
      ),
    );
  }
}