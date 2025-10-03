// lib/features/test/presentation/screens/calibration_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/utils/responsive_utils.dart';

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
    final responsive = ResponsiveUtils(context);
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
                padding: EdgeInsets.all(responsive.wp(5)),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/test-detail'),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: responsive.wp(4)),
                    Text(
                      'Camera Calibration',
                      style: TextStyle(
                        fontSize: responsive.sp(24).clamp(22.0, 28.0),
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
                  margin: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(responsive.wp(6)),
                    border: Border.all(
                      color: AppColors.royalPurple.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(responsive.wp(5.5)),
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
                padding: EdgeInsets.all(responsive.wp(5)),
                child: GlassCard(
                  padding: EdgeInsets.all(responsive.wp(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calibration Instructions',
                        style: TextStyle(
                          fontSize: responsive.sp(18).clamp(16.0, 20.0),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: responsive.hp(2)),
                      _buildCalibrationStep(
                        '1',
                        'Position your phone 5-10 meters from the start line',
                        Icons.location_on,
                      ),
                      SizedBox(height: responsive.hp(1.5)),
                      _buildCalibrationStep(
                        '2',
                        'Ensure the entire 40m track is visible in frame',
                        Icons.visibility,
                      ),
                      SizedBox(height: responsive.hp(1.5)),
                      _buildCalibrationStep(
                        '3',
                        'Keep the camera steady and level',
                        Icons.straighten,
                      ),
                      SizedBox(height: responsive.hp(1.5)),
                      _buildCalibrationStep(
                        '4',
                        'Test the view by standing at the start line',
                        Icons.accessibility,
                      ),
                      SizedBox(height: responsive.hp(3)),

                      // Calibration Status
                      Container(
                        padding: EdgeInsets.all(responsive.wp(4)),
                        decoration: BoxDecoration(
                          color: _isCalibrating
                              ? AppColors.neonGreen.withOpacity(0.1)
                              : AppColors.royalPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(responsive.wp(3)),
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
