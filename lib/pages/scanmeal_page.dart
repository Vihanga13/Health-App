import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScanMealPage extends StatefulWidget {
  const ScanMealPage({Key? key}) : super(key: key);

  @override
  State<ScanMealPage> createState() => _ModernScanMealPageState();
}

class _ModernScanMealPageState extends State<ScanMealPage> with TickerProviderStateMixin {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isScanning = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _scanAnimationController;
  final Color customGreen = const Color(0xFF86BF3E);

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _setupAnimations();
  }

  void _setupAnimations() {
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final status = await Permission.camera.request();
    if (status.isGranted) {
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await _controller!.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
      } catch (e) {
        print('Error initializing camera: $e');
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _processImage(_selectedImage!);
      });
    }
  }

  void _processImage(File image) {
    setState(() {
      _isScanning = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isScanning = false;
      });
      _showModernResultDialog();
    });
  }

  void _scanMeal() async {
    try {
      if (_controller != null && _controller!.value.isInitialized) {
        setState(() {
          _isScanning = true;
        });

        final image = await _controller!.takePicture();
        final File imageFile = File(image.path);
        _processImage(imageFile);
      }
    } catch (e) {
      print('Error taking picture: $e');
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _showModernResultDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: customGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: customGreen,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Scan Complete',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: customGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your meal has been successfully scanned!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: customGreen,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera or Selected Image
            Positioned.fill(
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : _isCameraInitialized
                      ? CameraPreview(_controller!)
                      : Container(
                          color: Colors.black,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
            ),

            // Scanning Animation
            if (_isScanning)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: AnimatedBuilder(
                    animation: _scanAnimationController,
                    builder: (context, child) {
                      return Container(
                        height: 2,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height *
                              _scanAnimationController.value,
                        ),
                        color: customGreen,
                      );
                    },
                  ),
                ),
              ),

            // Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  
                    const Text(
                      'Scan Your Meal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isScanning ? 'Analyzing your meal...' : 'Center your meal in the frame',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircularButton(
                          icon: Icons.photo_library,
                          label: 'Gallery',
                          onTap: _isScanning ? null : _pickImageFromGallery,
                        ),
                        _buildCameraButton(),
                        _buildCircularButton(
                          icon: Icons.flash_on,
                          label: 'Flash',
                          onTap: () {
                            // Add flash functionality
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: _isScanning ? null : _scanMeal,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: customGreen,
          boxShadow: [
            BoxShadow(
              color: customGreen.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _isScanning ? Icons.hourglass_bottom : Icons.camera_alt,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}