// lib/features/test/presentation/screens/video_analysis_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/video_analysis_service.dart';
import '../../../../core/services/convex_http_service.dart';
import '../../../../core/services/resend_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';


class VideoAnalysisScreen extends StatefulWidget {
  final String videoPath;
  final ExerciseType exerciseType;
  
  const VideoAnalysisScreen({
    super.key,
    required this.videoPath,
    required this.exerciseType,
  });

  @override
  State<VideoAnalysisScreen> createState() => _VideoAnalysisScreenState();
}

class _VideoAnalysisScreenState extends State<VideoAnalysisScreen>
    with TickerProviderStateMixin {
  bool _isAnalyzing = true;
  bool _analysisComplete = false;
  double _analysisProgress = 0.0;
  String _currentStage = 'Preparing video...';
  ExerciseMetrics? _results;
  String? _errorMessage;

  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  final List<String> _analysisStages = [
    'Preparing video...',
    'Detecting poses...',
    'Analyzing movement...',
    'Counting repetitions...',
    'Evaluating form...',
    'Calculating scores...',
    'Finalizing results...',
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnalysis();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  Future<void> _startAnalysis() async {
    try {
      final videoFile = File(widget.videoPath);
      
      // Simulate analysis stages with progress updates
      for (int i = 0; i < _analysisStages.length; i++) {
        if (mounted) {
          setState(() {
            _currentStage = _analysisStages[i];
            _analysisProgress = (i + 1) / _analysisStages.length;
          });
          
          _progressController.animateTo(_analysisProgress);
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }

      // Perform actual ML analysis
      final results = await VideoAnalysisService.analyzeVideoFile(
        videoFile: videoFile,
        exerciseType: widget.exerciseType,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _analysisProgress = progress;
            });
            _progressController.animateTo(progress);
          }
        },
      );

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _analysisComplete = true;
          _results = results;
          _currentStage = 'Analysis complete!';
        });
        
        _pulseController.stop();
        
        // Save results to backend
        await _saveResults(results);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = 'Analysis failed: ${e.toString()}';
        });
        _pulseController.stop();
      }
    }
  }

  Future<void> _saveResults(ExerciseMetrics results) async {
    try {
      // For demo purposes, we'll use one of our synthetic users
      // In a real app, you'd get this from authentication
      final syntheticUsers = [
        'alex_johnson_id',
        'sarah_martinez_id', 
        'mike_chen_id',
        'emma_wilson_id'
      ];
      
      // Use a random synthetic user ID for demo
      final userId = syntheticUsers[0]; // Use first user for consistency
      final userEmail = 'alex.johnson@example.com'; // Demo email for synthetic user
      final userName = 'Alex Johnson'; // Demo name for synthetic user
      
      print('Saving results for user: $userId');
      print('Exercise: ${widget.exerciseType}');
      print('Score: ${results.overallScore}');
      
      // Save to Convex backend (this will update leaderboard automatically)
      await ConvexHttpService().submitTestResult(
        userId: userId,
        testId: '${widget.exerciseType.toString().split('.').last}_${DateTime.now().millisecondsSinceEpoch}',
        score: results.overallScore,
        mlAnalysis: results.toMap(),
        videoUrl: widget.videoPath,
      );
      
      print('✅ Results saved to Convex backend successfully!');
      
      // Send test completion email using Resend
      try {
        await ResendService.sendTestCompletionEmail(
          toEmail: userEmail,
          userName: userName,
          testName: VideoAnalysisService.getExerciseName(widget.exerciseType),
          score: results.overallScore,
        );
        print('✅ Test completion email sent via Resend successfully!');
      } catch (emailError) {
        print('⚠️ Failed to send test completion email: $emailError');
        // Don't block the user flow if email fails
      }
      
      print('🎉 Complete user journey: Test → Analysis → Leaderboard Update → Email Notification');
    } catch (e) {
      print('Failed to save results: $e');
      // Don't block the user flow if saving fails
    }
  }

  void _viewDetailedResults() {
    if (_results != null) {
      context.push(
        '/test/results',
        extra: {
          'results': _results,
          'exercise_type': widget.exerciseType,
        },
      );
    }
  }

  void _retakeTest() {
    // Navigate back to home to select another test
    context.go('/home');
  }

  Widget _buildMetricCard(String title, double value, String unit, IconData icon) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
                      onPressed: _isAnalyzing ? null : () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: _isAnalyzing ? Colors.grey : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Test Analysis',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _isAnalyzing
                      ? _buildAnalysisProgress()
                      : _errorMessage != null
                          ? _buildErrorView()
                          : _buildResults(),
                ),
              ),

              // Bottom Actions
              if (!_isAnalyzing) ...[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _retakeTest,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Retake Test',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _analysisComplete ? _viewDetailedResults : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'View Results',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
    );
  }

  Widget _buildAnalysisProgress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: AppColors.primary,
                  size: 60,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        
        Text(
          _currentStage,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        
        GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${(_analysisProgress * 100).toInt()}%',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: Colors.grey[700],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        const Text(
          'This may take a few moments...',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 80,
        ),
        const SizedBox(height: 24),
        Text(
          'Analysis Failed',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _errorMessage ?? 'An unknown error occurred',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_results == null) return const SizedBox();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Overall Score
          GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Overall Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _results!.overallScore.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    VideoAnalysisService.getExerciseName(widget.exerciseType),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Metrics Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildMetricCard(
                'Repetitions',
                _results!.repetitions.toDouble(),
                'reps',
                Icons.repeat,
              ),
              _buildMetricCard(
                'Accuracy',
                _results!.accuracy,
                '%',
                Icons.gps_fixed,
              ),
              _buildMetricCard(
                'Speed',
                _results!.speed,
                'score',
                Icons.speed,
              ),
              _buildMetricCard(
                'Form',
                _results!.form,
                'score',
                Icons.fitness_center,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}