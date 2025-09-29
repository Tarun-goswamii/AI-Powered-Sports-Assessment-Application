// lib/features/test/presentation/screens/recording_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isCountdownActive = false;
  int _countdownValue = 3;
  Timer? _countdownTimer;
  Timer? _recordingTimer;
  int _recordingDuration = 0;
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseAnimationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera initialization failed: $e'),
            backgroundColor: AppColors.brightRed,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _countdownTimer?.cancel();
    _recordingTimer?.cancel();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isCountdownActive = true;
      _countdownValue = 3;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownValue--;
      });

      if (_countdownValue == 0) {
        timer.cancel();
        _startRecording();
      }
    });
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _isCountdownActive = false;
        _recordingDuration = 0;
      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration++;
        });

        // Auto-stop after 45 seconds (typical sprint test duration)
        if (_recordingDuration >= 45) {
          _stopRecording();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording: $e'),
            backgroundColor: AppColors.brightRed,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      final file = await _cameraController!.stopVideoRecording();
      _recordingTimer?.cancel();

      setState(() {
        _isRecording = false;
      });

      // Navigate to completion screen with video file path
      if (mounted) {
        context.go('/test-completion');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to stop recording: $e'),
            backgroundColor: AppColors.brightRed,
          ),
        );
      }
    }
  }

  String _formatDuration(int seconds) {
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
          child: Stack(
            children: [
              Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => context.go('/calibration'),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Recording Test',
                            style: TextStyle(
                              fontSize: 24,
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
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _isRecording
                              ? AppColors.brightRed
                              : AppColors.royalPurple.withOpacity(0.3),
                          width: _isRecording ? 3 : 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: _isInitialized && _cameraController != null
                            ? CameraPreview(_cameraController!)
                            : Container(
                                color: AppColors.card,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.royalPurple,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),

                  // Recording Controls
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Recording Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _isRecording ? _pulseAnimation.value : 1.0,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: _isRecording
                                            ? AppColors.brightRed
                                            : AppColors.neonGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _isRecording
                                    ? 'Recording: ${_formatDuration(_recordingDuration)}'
                                    : 'Ready to Record',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _isRecording
                                      ? AppColors.brightRed
                                      : AppColors.neonGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Instructions
                          Text(
                            _isRecording
                                ? 'Sprint as fast as possible when ready!'
                                : 'Get ready at the start line. Press start when prepared.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary.withOpacity(0.9),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Control Buttons
                          Row(
                            children: [
                              if (!_isRecording && !_isCountdownActive) ...[
                                Expanded(
                                  child: NeonButton(
                                    text: 'Start Recording',
                                    onPressed: _startCountdown,
                                    size: NeonButtonSize.large,
                                  ),
                                ),
                              ] else if (_isRecording) ...[
                                Expanded(
                                  child: NeonButton(
                                    text: 'Stop Recording',
                                    variant: NeonButtonVariant.secondary,
                                    onPressed: _stopRecording,
                                    size: NeonButtonSize.large,
                                  ),
                                ),
                              ] else ...[
                                const Expanded(
                                  child: SizedBox(),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Countdown Overlay
              if (_isCountdownActive)
                Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: GlassCard(
                      padding: const EdgeInsets.all(40),
                      enableNeonGlow: true,
                      neonGlowColor: AppColors.electricBlue,
                      child: Text(
                        _countdownValue.toString(),
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w900,
                          color: AppColors.electricBlue,
                        ),
                      ),
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
