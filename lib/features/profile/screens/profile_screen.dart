import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Sticky Header
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.primaryWithOpacity10),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    ),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: IconButton(
                        icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
                        onPressed: () {
                          // TODO: More options
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  const ProfileHeader(),

                  // SOS Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Trigger SOS
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 8,
                          shadowColor: AppColors.primaryWithOpacity20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.emergency_share, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Broadcast Emergency SOS',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Emergency Information Section
                  const ProfileSection(
                    title: 'Emergency Information',
                    items: [
                      ProfileSectionItem(
                        icon: Icons.contact_emergency,
                        iconColor: AppColors.primary,
                        iconBgColor: AppColors.primaryWithOpacity10,
                        title: 'Emergency Contacts (ICE)',
                        subtitle: 'Mom, Dad • 2 contacts saved',
                      ),
                      ProfileSectionItem(
                        icon: Icons.medical_services,
                        iconColor: AppColors.primary,
                        iconBgColor: AppColors.primaryWithOpacity10,
                        title: 'Medical Profile',
                        subtitle: 'Type A+, Nut Allergy, Asthma',
                        showDivider: false,
                      ),
                    ],
                  ),

                  // My Activity Section
                  const ProfileSection(
                    title: 'My Activity',
                    items: [
                      ProfileSectionItem(
                        icon: Icons.description,
                        iconColor: AppColors.primary,
                        iconBgColor: AppColors.primaryWithOpacity10,
                        title: 'My Reports',
                        subtitle: '4 active, 12 resolved reports',
                        showDivider: false,
                      ),
                    ],
                  ),

                  // Application Settings Section
                  ProfileSection(
                    title: 'Application Settings',
                    items: [
                      ProfileSectionItem(
                        icon: Icons.notifications_active,
                        iconColor: const Color(0xFF475569),
                        iconBgColor: const Color(0xFFF1F5F9),
                        title: 'Notifications',
                        subtitle: 'Campus alerts & safe-walk status',
                      ),
                      ProfileSectionItem(
                        icon: Icons.security,
                        iconColor: const Color(0xFF475569),
                        iconBgColor: const Color(0xFFF1F5F9),
                        title: 'Privacy & Security',
                        subtitle: 'Location sharing permissions',
                      ),
                      ProfileSectionItem(
                        icon: Icons.help,
                        iconColor: const Color(0xFF475569),
                        iconBgColor: const Color(0xFFF1F5F9),
                        title: 'Help & Support',
                        subtitle: 'FAQs and campus safety guide',
                        showDivider: false,
                      ),
                    ],
                  ),

                  // Log Out Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Log out
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primaryWithOpacity20),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Version
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        'QuickReach Campus Edition v2.4.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
