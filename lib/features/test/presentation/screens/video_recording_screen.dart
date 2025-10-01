// lib/features/test/presentation/screens/video_recording_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/video_analysis_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';

class VideoRecordingScreen extends StatefulWidget {
  final ExerciseType exerciseType;
  final CameraController? cameraController;
  
  const VideoRecordingScreen({
    super.key,
    required this.exerciseType,
    this.cameraController,
  });

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isCountingDown = false;
  int _countdown = 3;
  int _testDuration = 0;
  int _elapsedTime = 0;
  Timer? _countdownTimer;
  Timer? _recordingTimer;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _testDuration = VideoAnalysisService.getExerciseDuration(widget.exerciseType);
    _initializeCamera();
    _setupAnimations();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _recordingTimer?.cancel();
    _pulseController.dispose();
    if (widget.cameraController == null) {
      _cameraController?.dispose();
    }
    super.dispose();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeCamera() async {
    if (widget.cameraController != null) {
      _cameraController = widget.cameraController;
      setState(() {});
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // For mobile devices, prefer back camera for better exercise recording
        final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );

        _cameraController = CameraController(
          backCamera,
          ResolutionPreset.medium, // Medium for mobile optimization
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        await _cameraController!.initialize();
        
        // Set mobile-optimized settings
        await _cameraController!.setFlashMode(FlashMode.off);
        await _cameraController!.setFocusMode(FocusMode.auto);
        await _cameraController!.setExposureMode(ExposureMode.auto);
        
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      // Show user-friendly error for mobile
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera access required for video recording. Please enable camera permissions.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startCountdown() {
    print('Starting countdown...');
    setState(() {
      _isCountingDown = true;
      _countdown = 3;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('Countdown: $_countdown');
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        print('Countdown finished, starting recording...');
        _startRecording();
      }
    });
  }

  Future<void> _startRecording() async {
    print('_startRecording called');
    if (_cameraController?.value.isInitialized != true) {
      print('Camera not initialized');
      _showErrorDialog('Camera not ready. Please try again.');
      return;
    }

    try {
      print('Starting video recording...');
      await _cameraController!.startVideoRecording();
      print('Video recording started successfully');
      
      setState(() {
        _isCountingDown = false;
        _isRecording = true;
        _elapsedTime = 0;
      });

      _pulseController.repeat(reverse: true);

      // Start recording timer
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedTime++;
        });

        print('Recording time: $_elapsedTime / $_testDuration');
        if (_elapsedTime >= _testDuration) {
          _stopRecording();
        }
      });
    } catch (e) {
      print('Recording start error: $e');
      _showErrorDialog('Failed to start recording: $e');
      setState(() {
        _isCountingDown = false;
        _isRecording = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recording Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _stopRecording() async {
    print('_stopRecording called');
    if (!_isRecording) {
      print('Not currently recording');
      return;
    }

    try {
      _recordingTimer?.cancel();
      _pulseController.stop();

      print('Stopping video recording...');
      final videoFile = await _cameraController!.stopVideoRecording();
      print('Video recorded to: ${videoFile.path}');
      
      setState(() {
        _isRecording = false;
      });

      // Navigate to analysis screen
      if (mounted) {
        print('Navigating to analysis screen...');
        context.push(
          '/test/analysis',
          extra: {
            'video_path': videoFile.path,
            'exercise_type': widget.exerciseType,
          },
        );
      }
    } catch (e) {
      print('Recording stop error: $e');
      _showErrorDialog('Failed to stop recording: $e');
      setState(() {
        _isRecording = false;
      });
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
                      onPressed: _isRecording ? null : () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: _isRecording ? Colors.grey : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        VideoAnalysisService.getExerciseName(widget.exerciseType),
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
                      child: _cameraController?.value.isInitialized == true
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                CameraPreview(_cameraController!),
                                
                                // Countdown overlay
                                if (_isCountingDown)
                                  Container(
                                    color: Colors.black.withOpacity(0.7),
                                    child: Center(
                                      child: AnimatedBuilder(
                                        animation: _pulseAnimation,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _pulseAnimation.value,
                                            child: Text(
                                              _countdown.toString(),
                                              style: const TextStyle(
                                                fontSize: 120,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                // Recording indicator
                                if (_isRecording)
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    child: AnimatedBuilder(
                                      animation: _pulseAnimation,
                                      builder: (context, child) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                'REC',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                // Timer
                                Positioned(
                                  top: 20,
                                  right: 20,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _isRecording
                                          ? _formatTime(_elapsedTime)
                                          : _formatTime(_testDuration),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              color: Colors.black,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              // Controls
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Progress indicator
                      if (_isRecording) ...[
                        GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Progress',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${((_elapsedTime / _testDuration) * 100).toInt()}%',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value: _elapsedTime / _testDuration,
                                  backgroundColor: Colors.grey[700],
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      const Spacer(),

                      // Control buttons
                      if (!_isRecording && !_isCountingDown) ...[
                        ElevatedButton(
                          onPressed: _startCountdown,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.play_arrow, size: 28),
                              SizedBox(width: 8),
                              Text(
                                'Start Test',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_isRecording) ...[
                        ElevatedButton(
                          onPressed: _stopRecording,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.stop, size: 28),
                              SizedBox(width: 8),
                              Text(
                                'Stop Test',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}