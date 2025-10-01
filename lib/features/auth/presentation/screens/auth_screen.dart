// lib/features/auth/presentation/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/service_manager.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoRotation;
  late Animation<double> _logoScale;
  late Animation<double> _fadeAnimation;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize animations
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _logoRotation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));
    
    _logoScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    // Start animations
    _logoController.forward();
    _fadeController.forward();
    _logoController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Enhanced Animated Logo
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_logoController, _fadeController]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.royalPurple,
                                  AppColors.electricBlue,
                                  AppColors.neonGreen.withOpacity(0.9),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.royalPurple.withOpacity(0.6),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: AppColors.electricBlue.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: const Offset(0, -3),
                                ),
                                BoxShadow(
                                  color: AppColors.neonGreen.withOpacity(0.3),
                                  blurRadius: 40,
                                  spreadRadius: 15,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.sports_soccer,
                              color: Colors.white,
                              size: 70,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.neonGreen,
                      AppColors.electricBlue,
                      AppColors.royalPurple,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    'Welcome to Vita Sports',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your journey to athletic excellence starts here',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mutedForeground.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Auth Form
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: AppColors.glassmorphismDecoration(
                    borderRadius: BorderRadius.circular(25),
                    enableNeonGlow: true,
                    neonGlowColor: AppColors.royalPurple,
                  ).copyWith(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.royalPurple.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: AppColors.electricBlue.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        // Tab Bar
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.glassmorphismBackground.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.glassmorphismBorder.withOpacity(0.6),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.royalPurple.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.royalPurple, AppColors.electricBlue],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.royalPurple.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            unselectedLabelColor: AppColors.mutedForeground,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            tabs: const [
                              Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text('Login'),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text('Sign Up'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Tab Bar View
                        SizedBox(
                          height: 400,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildLoginForm(),
                              _buildSignUpForm(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Social Auth
                _buildSocialAuth(),
                const SizedBox(height: 24),
                // Terms
                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withOpacity(0.6),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email Field
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(Icons.email, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.royalPurple, width: 2),
            ),
            filled: true,
            fillColor: AppColors.muted,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        // Password Field
        Container(
          decoration: AppColors.glassmorphismDecoration(
            borderRadius: BorderRadius.circular(15),
            enableNeonGlow: false,
          ),
          child: TextField(
            controller: _passwordController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppColors.mutedForeground,
                size: 22,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.mutedForeground,
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.glassmorphismBorder.withOpacity(0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.neonGreen,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _forgotPassword,
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: AppColors.royalPurple,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Error Message
        if (_errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        if (_errorMessage != null) const SizedBox(height: 16),
        // Login Button
        NeonButton(
          text: 'Login',
          onPressed: _isLoading ? null : _login,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        // Name Field
        Container(
          decoration: AppColors.glassmorphismDecoration(
            borderRadius: BorderRadius.circular(15),
            enableNeonGlow: false,
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Full Name',
              labelStyle: TextStyle(
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                color: AppColors.mutedForeground,
                size: 22,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.glassmorphismBorder.withOpacity(0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.neonGreen,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Email Field
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(Icons.email, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.royalPurple, width: 2),
            ),
            filled: true,
            fillColor: AppColors.muted,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        // Password Field
        TextField(
          controller: _passwordController,
          style: const TextStyle(color: Colors.white),
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(Icons.lock, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.royalPurple, width: 2),
            ),
            filled: true,
            fillColor: AppColors.muted,
          ),
        ),
        const SizedBox(height: 16),
        // Confirm Password Field
        TextField(
          controller: _confirmPasswordController,
          style: const TextStyle(color: Colors.white),
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.royalPurple, width: 2),
            ),
            filled: true,
            fillColor: AppColors.muted,
          ),
        ),
        const SizedBox(height: 24),
        // Error Message
        if (_errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        if (_errorMessage != null) const SizedBox(height: 16),
        // Sign Up Button
        NeonButton(
          text: 'Create Account',
          onPressed: _isLoading ? null : _signUp,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildSocialAuth() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.textSecondary.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.textSecondary.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Icons.g_mobiledata,
              label: 'Google',
              onPressed: _signInWithGoogle,
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              icon: Icons.facebook,
              label: 'Facebook',
              onPressed: _signInWithFacebook,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: AppColors.glassmorphismDecoration(
          borderRadius: BorderRadius.circular(15),
          enableNeonGlow: true,
          neonGlowColor: AppColors.electricBlue,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.glassmorphismBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.mutedForeground,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // First authenticate with the auth service
      final authService = ref.read(authServiceProvider);
      final userCredential = await authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      // Extract user data for persistence
      final userData = {
        'uid': userCredential.user?.uid ?? '',
        'email': userCredential.user?.email ?? '',
        'displayName': userCredential.user?.displayName ?? '',
        'photoURL': userCredential.user?.photoURL,
        'emailVerified': userCredential.user?.emailVerified ?? false,
      };
      
      // Get auth token if available
      final authToken = await userCredential.user?.getIdToken();
      
      // Use the auth state provider to persist the session
      final authNotifier = ref.read(authStateProvider.notifier);
      await authNotifier.login(
        userData: userData,
        authToken: authToken,
      );

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signUp() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // First create account with the auth service
      final authService = ref.read(authServiceProvider);
      final userCredential = await authService.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
      
      // Extract user data for persistence
      final userData = {
        'uid': userCredential.user?.uid ?? '',
        'email': userCredential.user?.email ?? '',
        'displayName': _nameController.text.trim(),
        'photoURL': userCredential.user?.photoURL,
        'emailVerified': userCredential.user?.emailVerified ?? false,
      };
      
      // Get auth token if available
      final authToken = await userCredential.user?.getIdToken();
      
      // Use the auth state provider to persist the session
      final authNotifier = ref.read(authStateProvider.notifier);
      await authNotifier.login(
        userData: userData,
        authToken: authToken,
      );

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _forgotPassword() {
    // TODO: Implement forgot password
  }

  void _signInWithGoogle() {
    // TODO: Implement Google sign in
  }

  void _signInWithFacebook() {
    // TODO: Implement Facebook sign in
  }
}
