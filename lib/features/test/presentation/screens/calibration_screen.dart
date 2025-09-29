// lib/features/test/presentation/screens/calibration_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({super.key});

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isCalibrating = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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
      // Handle camera initialization error
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
    super.dispose();
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
                      onPressed: () => context.go('/test-detail'),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Camera Calibration',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
                      color: AppColors.royalPurple.withOpacity(0.3),
                      width: 2,
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

              // Calibration Instructions
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calibration Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCalibrationStep(
                        '1',
                        'Position your phone 5-10 meters from the start line',
                        Icons.location_on,
                      ),
                      const SizedBox(height: 12),
                      _buildCalibrationStep(
                        '2',
                        'Ensure the entire 40m track is visible in frame',
                        Icons.visibility,
                      ),
                      const SizedBox(height: 12),
                      _buildCalibrationStep(
                        '3',
                        'Keep the camera steady and level',
                        Icons.straighten,
                      ),
                      const SizedBox(height: 12),
                      _buildCalibrationStep(
                        '4',
                        'Test the view by standing at the start line',
                        Icons.accessibility,
                      ),
                      const SizedBox(height: 24),

                      // Calibration Status
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isCalibrating
                              ? AppColors.neonGreen.withOpacity(0.1)
                              : AppColors.royalPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isCalibrating
                                ? AppColors.neonGreen
                                : AppColors.royalPurple,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isCalibrating ? Icons.check_circle : Icons.info,
                              color: _isCalibrating
                                  ? AppColors.neonGreen
                                  : AppColors.royalPurple,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isCalibrating
                                    ? 'Calibration complete! Ready to record.'
                                    : 'Adjust camera position for optimal view.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _isCalibrating
                                      ? AppColors.neonGreen
                                      : AppColors.royalPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: NeonButton(
                              text: _isCalibrating ? 'Recalibrate' : 'Calibrate',
                              variant: NeonButtonVariant.secondary,
                              onPressed: _toggleCalibration,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: NeonButton(
                              text: 'Start Recording',
                              onPressed: _isCalibrating
                                  ? () => context.go('/recording')
                                  : null,
                              size: NeonButtonSize.large,
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
      ),
    );
  }

  Widget _buildCalibrationStep(String step, String text, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.electricBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          icon,
          color: AppColors.royalPurple,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _toggleCalibration() {
    setState(() {
      _isCalibrating = !_isCalibrating;
    });

    if (_isCalibrating) {
      // Simulate calibration process
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isCalibrating = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Calibration successful!'),
              backgroundColor: Color(0xFF00FFB2),
            ),
          );
        }
      });
    }
  }
}
