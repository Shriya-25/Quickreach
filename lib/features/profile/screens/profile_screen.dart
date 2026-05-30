import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../models/user_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  UserModel? _user;
  bool _isLoading = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final user = await _firestoreService.getUserById(uid);
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log Out',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoggingOut = true);
    await _authService.signOut();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // ── Top bar ──────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.primaryWithOpacity10),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert,
                          color: AppColors.textPrimary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _user == null
                    ? _buildErrorState()
                    : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final user = _user!;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Profile Header (centered) ─────────────────────────────────
          ProfileHeader(user: user),

          // ── SOS Button ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Trigger SOS
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: AppColors.primaryWithOpacity20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emergency_share_rounded, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Broadcast Emergency SOS',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Emergency Information ─────────────────────────────────────
          ProfileSection(
            title: 'Emergency Information',
            items: [
              ProfileSectionItem(
                icon: Icons.contact_emergency_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primaryWithOpacity10,
                title: 'Emergency Contacts (ICE)',
                subtitle: 'Add your emergency contacts',
                onTap: () {},
              ),
              ProfileSectionItem(
                icon: Icons.medical_services_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primaryWithOpacity10,
                title: 'Medical Profile',
                subtitle: 'Add blood group, allergies, conditions',
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),

          // ── My Activity ───────────────────────────────────────────────
          ProfileSection(
            title: 'My Activity',
            items: [
              ProfileSectionItem(
                icon: Icons.description_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primaryWithOpacity10,
                title: 'My Reports',
                subtitle: 'View your submitted reports',
                showDivider: false,
                onTap: () => context.go('/reports'),
              ),
            ],
          ),

          // ── Application Settings ──────────────────────────────────────
          ProfileSection(
            title: 'Application Settings',
            items: [
              ProfileSectionItem(
                icon: Icons.notifications_active_rounded,
                iconColor: const Color(0xFF475569),
                iconBgColor: const Color(0xFFF1F5F9),
                title: 'Notifications',
                subtitle: 'Campus alerts & emergency updates',
                onTap: () {},
              ),
              ProfileSectionItem(
                icon: Icons.security_rounded,
                iconColor: const Color(0xFF475569),
                iconBgColor: const Color(0xFFF1F5F9),
                title: 'Privacy & Security',
                subtitle: 'Manage your account security',
                onTap: () {},
              ),
              ProfileSectionItem(
                icon: Icons.help_rounded,
                iconColor: const Color(0xFF475569),
                iconBgColor: const Color(0xFFF1F5F9),
                title: 'Help & Support',
                subtitle: 'FAQs and campus safety guide',
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),

          // ── Account Info ──────────────────────────────────────────────
          ProfileSection(
            title: 'Account',
            items: [
              ProfileSectionItem(
                icon: Icons.badge_rounded,
                iconColor: const Color(0xFF475569),
                iconBgColor: const Color(0xFFF1F5F9),
                title: 'College ID',
                subtitle: user.collegeId.isNotEmpty ? user.collegeId : '—',
                showDivider: true,
                onTap: null,
              ),
              ProfileSectionItem(
                icon: Icons.school_rounded,
                iconColor: const Color(0xFF475569),
                iconBgColor: const Color(0xFFF1F5F9),
                title: 'Role',
                subtitle: user.role,
                showDivider: true,
                onTap: null,
              ),
              ProfileSectionItem(
                icon: Icons.mail_rounded,
                iconColor: const Color(0xFF475569),
                iconBgColor: const Color(0xFFF1F5F9),
                title: 'Email',
                subtitle: user.email,
                showDivider: false,
                onTap: null,
              ),
            ],
          ),

          // ── Log Out ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _isLoggingOut ? null : _handleLogout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primaryWithOpacity20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoggingOut
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Log Out',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // ── Version ───────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 8),
            child: Center(
              child: Text(
                'QuickReach v1.0.0',
                style: TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 48, color: AppColors.textHint),
          const SizedBox(height: 12),
          const Text('Could not load profile',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() => _isLoading = true);
              _loadUser();
            },
            child: const Text('Retry',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
