import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/staff_model.dart';

class StaffListItem extends StatelessWidget {
  final StaffModel staff;
  final VoidCallback onCallTap;
  final VoidCallback? onEmailTap; // null = don't show email button

  const StaffListItem({
    super.key,
    required this.staff,
    required this.onCallTap,
    this.onEmailTap,
  });

  // Role badge color
  Color get _roleColor {
    switch (staff.role) {
      case 'Principal':
        return const Color(0xFF7C3AED); // purple
      case 'HOD':
        return const Color(0xFF0369A1); // blue
      case 'Faculty':
        return AppColors.primary;
      case 'Security':
        return const Color(0xFF059669); // green
      default:
        return AppColors.textSecondary;
    }
  }

  Color get _roleBgColor {
    switch (staff.role) {
      case 'Principal':
        return const Color(0xFFF3E8FF);
      case 'HOD':
        return const Color(0xFFE0F2FE);
      case 'Faculty':
        return AppColors.primaryWithOpacity10;
      case 'Security':
        return const Color(0xFFD1FAE5);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showEmail = onEmailTap != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Avatar ──────────────────────────────────────────────────────
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _roleBgColor,
              border: Border.all(color: _roleColor.withValues(alpha: 0.3), width: 2),
            ),
            child: Center(
              child: Text(
                staff.name.isNotEmpty ? staff.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _roleColor,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ── Name + dept + role badge ─────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _roleBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        staff.role,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _roleColor,
                          letterSpacing: 0.3,
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
                            color: AppColors.textSecondary,
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

          // ── Action buttons ───────────────────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Call — always shown
              _ActionButton(
                icon: Icons.call_rounded,
                color: AppColors.success,
                bgColor: const Color(0xFFD1FAE5),
                onTap: onCallTap,
                tooltip: 'Call ${staff.name}',
              ),

              // Email — only for Faculty / HOD / Principal
              if (showEmail) ...[
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.mail_rounded,
                  color: AppColors.primary,
                  bgColor: AppColors.primaryWithOpacity10,
                  onTap: onEmailTap!,
                  tooltip: 'Email ${staff.name}',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
