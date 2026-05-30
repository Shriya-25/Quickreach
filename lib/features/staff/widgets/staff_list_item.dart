import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/staff_model.dart';

class StaffListItem extends StatelessWidget {
  final StaffModel staff;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCallTap;

  const StaffListItem({
    super.key,
    required this.staff,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onCallTap,
  });

  // ── Role badge colors — blue-grey palette ──────────────────────────────
  Color get _roleBadgeText {
    switch (staff.role) {
      case 'Principal':
        return const Color(0xFF1E3A5F); // dark blue
      case 'HOD':
        return const Color(0xFF2C5282); // blue
      case 'Faculty':
        return const Color(0xFF475569); // slate grey
      case 'Staff':
        return const Color(0xFF374151); // dark grey
      case 'Security':
        return const Color(0xFF92400E); // dark amber
      default:
        return AppColors.textSecondary;
    }
  }

  Color get _roleBadgeBg {
    switch (staff.role) {
      case 'Principal':
        return const Color(0xFFDBEAFE); // light blue
      case 'HOD':
        return const Color(0xFFE2EAF4); // soft blue-grey
      case 'Faculty':
        return const Color(0xFFF1F5F9); // very light grey
      case 'Staff':
        return const Color(0xFFE5E7EB); // light grey
      case 'Security':
        return const Color(0xFFFEF3C7); // soft amber
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Avatar — consistent blue-grey for all ──────────────────────
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEEF2F7),
              border: Border.all(
                color: const Color(0xFFCDD5E0),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                staff.name.isNotEmpty ? staff.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ── Name + role badge + department ─────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _roleBadgeBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        staff.role.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: _roleBadgeText,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (staff.department.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          staff.department,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Actions: Favourite + Call ──────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Favourite
              GestureDetector(
                onTap: onFavoriteTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFavorite
                        ? AppColors.primaryWithOpacity10
                        : const Color(0xFFF1F5F9),
                  ),
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 17,
                    color: isFavorite
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Call
              GestureDetector(
                onTap: onCallTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEEF2F7),
                  ),
                  child: const Icon(
                    Icons.call_rounded,
                    size: 17,
                    color: Color(0xFF2C5282),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
