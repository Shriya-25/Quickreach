import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ── Forms ──────────────────────────────────────────────────────────────────
  final _studentFormKey = GlobalKey<FormState>();
  final _adminFormKey = GlobalKey<FormState>();

  // Student/Staff fields
  final _collegeIdController = TextEditingController();
  final _studentPasswordController = TextEditingController();
  bool _rememberMe = false;

  // Admin fields
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();

  // Shared state
  final _authService = AuthService();
  bool _obscureStudentPassword = true;
  bool _obscureAdminPassword = true;
  bool _isLoading = false;

  // ── Tab animation ──────────────────────────────────────────────────────────
  late TabController _tabController;
  int _selectedTab = 0; // 0 = Student/Staff, 1 = Admin

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _collegeIdController.dispose();
    _studentPasswordController.dispose();
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  Future<void> _handleStudentLogin() async {
    if (!_studentFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // College ID login: treat as email (org may suffix domain) or direct email
      await _authService.signIn(
        email: _collegeIdController.text.trim(),
        password: _studentPasswordController.text,
      );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAdminLogin() async {
    if (!_adminFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.signIn(
        email: _adminEmailController.text.trim(),
        password: _adminPasswordController.text,
      );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword(TextEditingController emailCtrl) async {
    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email / College ID first')),
      );
      return;
    }
    try {
      await _authService.resetPassword(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent. Check your inbox.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // ── Header ────────────────────────────────────────────────────
              _buildHeader(),

              const SizedBox(height: 36),

              // ── Role Toggle ───────────────────────────────────────────────
              _buildRoleToggle(),

              const SizedBox(height: 32),

              // ── Form (animated switch) ────────────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _selectedTab == 0
                    ? _buildStudentForm(key: const ValueKey('student'))
                    : _buildAdminForm(key: const ValueKey('admin')),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryWithOpacity30,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.shield_rounded, color: Colors.white, size: 38),
        ),
        const SizedBox(height: 20),
        const Text(
          'QuickReach',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Campus Safety & Emergency Communication',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Stay connected, informed, and prepared\nduring emergencies.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Role Toggle ────────────────────────────────────────────────────────────
  Widget _buildRoleToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECEF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildToggleTab('Student / Staff', 0),
          _buildToggleTab('Admin', 1),
        ],
      ),
    );
  }

  Widget _buildToggleTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTab = index);
          _tabController.animateTo(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                index == 0 ? Icons.school_rounded : Icons.admin_panel_settings_rounded,
                size: 16,
                color: isSelected ? AppColors.primary : AppColors.textHint,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Student / Staff Form ───────────────────────────────────────────────────
  Widget _buildStudentForm({Key? key}) {
    return Form(
      key: _studentFormKey,
      child: Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // College ID
          _fieldLabel('College ID'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _collegeIdController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: _inputDeco(
              hint: 'Enter your College ID',
              icon: Icons.badge_outlined,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your College ID';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Password row with Forgot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fieldLabel('Password'),
              GestureDetector(
                onTap: () => _handleForgotPassword(_collegeIdController),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _studentPasswordController,
            obscureText: _obscureStudentPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleStudentLogin(),
            decoration: _inputDeco(
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              suffix: _eyeButton(
                obscure: _obscureStudentPassword,
                onTap: () => setState(() => _obscureStudentPassword = !_obscureStudentPassword),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your password';
              if (v.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Remember Me
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _rememberMe,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  side: const BorderSide(color: AppColors.border),
                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Remember Me',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Login Button
          _primaryButton(
            label: 'Login',
            onTap: _isLoading ? null : _handleStudentLogin,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 16),

          // Create Account
          Center(
            child: GestureDetector(
              onTap: () => context.go('/signup'),
              child: RichText(
                text: const TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  children: [
                    TextSpan(
                      text: 'Create Account',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Approval info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryWithOpacity10,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryWithOpacity20),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Access is granted after administrator approval.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Admin Form ─────────────────────────────────────────────────────────────
  Widget _buildAdminForm({Key? key}) {
    return Form(
      key: _adminFormKey,
      child: Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Admin Email
          _fieldLabel('Admin Email'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _adminEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _inputDeco(
              hint: 'admin@institution.edu',
              icon: Icons.alternate_email_rounded,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your email';
              if (!v.contains('@')) return 'Please enter a valid email';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Password row with Forgot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fieldLabel('Password'),
              GestureDetector(
                onTap: () => _handleForgotPassword(_adminEmailController),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _adminPasswordController,
            obscureText: _obscureAdminPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleAdminLogin(),
            decoration: _inputDeco(
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              suffix: _eyeButton(
                obscure: _obscureAdminPassword,
                onTap: () => setState(() => _obscureAdminPassword = !_obscureAdminPassword),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your password';
              if (v.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),

          const SizedBox(height: 28),

          // Login Button
          _primaryButton(
            label: 'Login',
            onTap: _isLoading ? null : _handleAdminLogin,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 20),

          // Admin note — no Create Account
          Center(
            child: Text(
              'Admin accounts are created by the organization.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────
  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _eyeButton({required bool obscure, required VoidCallback onTap}) {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: AppColors.textHint,
        size: 20,
      ),
      onPressed: onTap,
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: AppColors.primaryWithOpacity30,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
      filled: true,
      fillColor: AppColors.surface,
      prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
