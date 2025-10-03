// lib/features/test_flow/screens/enhanced_recording_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/dynamic_data_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/neon_button.dart';

class EnhancedRecordingScreen extends ConsumerStatefulWidget {
  final String testId;
  final String testName;

  const EnhancedRecordingScreen({
    Key? key,
    required this.testId,
    required this.testName,
  }) : super(key: key);

  @override
  ConsumerState<EnhancedRecordingScreen> createState() => _EnhancedRecordingScreenState();
}

class _EnhancedRecordingScreenState extends ConsumerState<EnhancedRecordingScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  bool _isInitialized = false;
  String? _videoPath;
  
  // Timer
  late AnimationController _timerController;
  Duration _recordingDuration = Duration.zero;
  DateTime? _recordingStartTime;
  
  // UI Animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  // Live feedback
  String _liveFeedback = 'Position yourself in frame';
  Color _feedbackColor = AppColors.royalPurple;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _timerController = AnimationController(
      duration: const Duration(minutes: 5), // Max recording time
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras!.first,
          ResolutionPreset.high,
          enableAudio: true,
        );
        
        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _startLiveFeedback();
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      _showErrorDialog('Camera initialization failed');
    }
  }

  void _startLiveFeedback() {
    // Simulate live ML feedback
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_isRecording || !mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        final feedbacks = [
          ('Perfect position!', AppColors.electricGreen),
          ('Move closer to camera', AppColors.sunsetOrange),
          ('Great form!', AppColors.electricGreen),
          ('Keep your back straight', AppColors.sunsetOrange),
          ('Excellent technique!', AppColors.electricGreen),
        ];
        
        final randomFeedback = feedbacks[DateTime.now().millisecond % feedbacks.length];
        _liveFeedback = randomFeedback.$1;
        _feedbackColor = randomFeedback.$2;
      });
    });
  }

  Future<void> _startRecording() async {
    if (!_isInitialized || _cameraController == null) return;
    
    try {
      final directory = await getTemporaryDirectory();
      final fileName = 'test_${widget.testId}_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final filePath = '${directory.path}/$fileName';
      
      await _cameraController!.startVideoRecording();
      
      setState(() {
        _isRecording = true;
        _recordingStartTime = DateTime.now();
        _videoPath = filePath;
        _liveFeedback = 'Recording started! ${widget.testName}';
        _feedbackColor = AppColors.electricGreen;
      });
      
      _timerController.forward();
      _startTimer();
      _startLiveFeedback();
      
    } catch (e) {
      print('Error starting recording: $e');
      _showErrorDialog('Failed to start recording');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording || _cameraController == null) return;
    
    try {
      final video = await _cameraController!.stopVideoRecording();
      
      setState(() {
        _isRecording = false;
        _videoPath = video.path;
        _liveFeedback = 'Recording completed!';
        _feedbackColor = AppColors.electricGreen;
      });
      
      _timerController.stop();
      
      // Process the recorded video
      await _processRecording(video.path);
      
    } catch (e) {
      print('Error stopping recording: $e');
      _showErrorDialog('Failed to stop recording');
    }
  }

  Future<void> _processRecording(String videoPath) async {
    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ProcessingDialog(),
    );
    
    try {
      final user = ref.read(userProvider);
      if (user == null) {
        throw Exception('User not found');
      }
      
      // Submit test with ML analysis through integrated service
      await ref.read(testSubmissionProvider.notifier).submitTest(
        userId: user.id,
        testId: widget.testId,
        videoPath: videoPath,
        videoDuration: _recordingDuration,
        userEmail: user.email,
        userName: user.name,
      );
      
      if (mounted) {
        Navigator.of(context).pop(); // Close processing dialog
        
        // Navigate to completion screen
        context.pushReplacement('/test-completion', extra: {
          'testId': widget.testId,
          'testName': widget.testName,
        });
      }
      
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close processing dialog
        _showErrorDialog('Failed to process recording: $e');
      }
    }
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRecording || !mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _recordingDuration = DateTime.now().difference(_recordingStartTime!);
      });
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
        title: const Text('Error', style: TextStyle(color: AppColors.textPrimary)),
        content: Text(message, style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: AppColors.royalPurple)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final testSubmissionState = ref.watch(testSubmissionProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.testName,
                          style: AppTypography.headingLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Record your performance',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Camera Preview
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _isInitialized && _cameraController != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            CameraPreview(_cameraController!),
                            
                            // Live feedback overlay
                            Positioned(
                              top: 20,
                              left: 20,
                              right: 20,
                              child: GlassCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: _feedbackColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _liveFeedback,
                                          style: AppTypography.bodyMedium.copyWith(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            // Recording indicator
                            if (_isRecording)
                              Positioned(
                                top: 20,
                                right: 20,
                                child: AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.red.withOpacity(0.5),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.fiber_manual_record,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            
                            // Timer overlay
                            if (_isRecording)
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GlassCard(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      _formatDuration(_recordingDuration),
                                      style: AppTypography.headingMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.royalPurple,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Instructions and Controls
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Instructions
                    GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              _getInstructions(),
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (_isRecording) ...[
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value: _timerController.value,
                                backgroundColor: AppColors.surfaceColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.royalPurple,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel/Retry Button
                        if (_isRecording)
                          NeonButton(
                            onPressed: () async {
                              await _stopRecording();
                              setState(() {
                                _recordingDuration = Duration.zero;
                                _videoPath = null;
                              });
                            },
                            variant: NeonButtonVariant.secondary,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.stop, size: 20),
                                SizedBox(width: 8),
                                Text('Stop'),
                              ],
                            ),
                          )
                        else
                          NeonButton(
                            onPressed: () => context.pop(),
                            variant: NeonButtonVariant.secondary,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.close, size: 20),
                                SizedBox(width: 8),
                                Text('Cancel'),
                              ],
                            ),
                          ),
                        
                        // Record Button
                        if (!_isRecording)
                          NeonButton(
                            onPressed: _isInitialized ? _startRecording : null,
                            variant: NeonButtonVariant.primary,
                            loading: !_isInitialized,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_circle, size: 24),
                                SizedBox(width: 8),
                                Text('Start Recording'),
                              ],
                            ),
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

  String _getInstructions() {
    if (_isRecording) {
      return 'Recording in progress. Perform the ${widget.testName} exercise. AI is analyzing your form in real-time.';
    } else {
      return 'Position yourself in the camera frame. Ensure good lighting and clear visibility. Tap "Start Recording" when ready.';
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

class ProcessingDialog extends StatelessWidget {
  const ProcessingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.royalPurple,
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              Text(
                'Processing Video',
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Our AI is analyzing your performance...',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}