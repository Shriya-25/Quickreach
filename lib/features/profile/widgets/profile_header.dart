import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar ──────────────────────────────────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryWithOpacity10,
                  border: Border.all(
                    color: AppColors.primaryWithOpacity20,
                    width: 3,
                  ),
                ),
                child: user.profilePhoto != null && user.profilePhoto!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          user.profilePhoto!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => _defaultAvatar(),
                        ),
                      )
                    : _defaultAvatar(),
              ),
              // Edit badge
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Full Name ────────────────────────────────────────────────────
          Text(
            user.fullName.isNotEmpty ? user.fullName : 'Unknown User',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          // ── College ID badge ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryWithOpacity10,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.primaryWithOpacity20),
            ),
            child: Text(
              user.collegeId.isNotEmpty ? user.collegeId : 'No ID',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Role + University line ────────────────────────────────────────
          Text(
            '${user.role} • QuickReach Campus',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          // ── Email ────────────────────────────────────────────────────────
          Text(
            user.email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textHint,
            ),
          ),

          const SizedBox(height: 12),

          // ── Approval status chip ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Approved',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Center(
      child: Text(
        user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
