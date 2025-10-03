// lib/features/test/presentation/screens/camera_calibration_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/video_analysis_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';

class CameraCalibrationScreen extends StatefulWidget {
  final ExerciseType exerciseType;
  
  const CameraCalibrationScreen({
    super.key,
    required this.exerciseType,
  });

  @override
  State<CameraCalibrationScreen> createState() => _CameraCalibrationScreenState();
}

class _CameraCalibrationScreenState extends State<CameraCalibrationScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isAnalyzing = false;
  bool _isReadyForTest = false;
  String _feedback = 'Initializing camera...';
  double _confidence = 0.0;
  Timer? _analysisTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _analysisTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras?.isNotEmpty == true) {
        // Use front camera for better user experience
        final frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first,
        );

        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _feedback = 'Position yourself in the camera view';
          });
          _startAnalysis();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _feedback = 'Camera initialization failed: $e';
        });
      }
    }
  }

  void _startAnalysis() {
    _analysisTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_cameraController?.value.isInitialized == true && !_isAnalyzing) {
        _analyzePose();
      }
    });
  }

  Future<void> _analyzePose() async {
    if (_isAnalyzing || _cameraController?.value.isInitialized != true) return;
    
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      
      final analysis = await VideoAnalysisService.analyzeCameraFeed(
        bytes,
        widget.exerciseType,
      );

      if (mounted) {
        setState(() {
          _isReadyForTest = analysis['ready_for_test'] ?? false;
          _confidence = analysis['confidence'] ?? 0.0;
          _feedback = analysis['feedback'] ?? 'Analyzing...';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _feedback = 'Analysis error: Please try again';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  void _startTest() {
    if (_isReadyForTest) {
      context.push(
        '/test/recording',
        extra: {
          'exercise_type': widget.exerciseType,
          'camera_controller': _cameraController,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Calibration - ${VideoAnalysisService.getExerciseName(widget.exerciseType)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Camera Preview
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _isInitialized && _cameraController != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                CameraPreview(_cameraController!),
                                
                                // Overlay indicators
                                Positioned(
                                  top: 20,
                                  left: 20,
                                  right: 20,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: _isReadyForTest 
                                                ? Colors.green 
                                                : Colors.orange,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _feedback,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Confidence indicator
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  right: 20,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Pose Detection: ${(_confidence * 100).toInt()}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        LinearProgressIndicator(
                                          value: _confidence,
                                          backgroundColor: Colors.grey[700],
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            _confidence > 0.8
                                                ? Colors.green
                                                : _confidence > 0.5
                                                    ? Colors.orange
                                                    : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              color: Colors.black,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _feedback,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              // Instructions and Controls
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Instructions
                      GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Calibration Instructions:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInstruction('1. Position yourself in camera view'),
                              _buildInstruction('2. Ensure good lighting'),
                              _buildInstruction('3. Stand at arm\'s length from camera'),
                              _buildInstruction('4. Wait for green indicator'),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Start Test Button
                      ElevatedButton(
                        onPressed: _isReadyForTest ? _startTest : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isReadyForTest ? AppColors.primary : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            _isReadyForTest ? 'Start Test' : 'Calibrating...',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}