import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class StaffListItem extends StatelessWidget {
  final String name;
  final String department;
  final String? imageUrl;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onContactTap;

  const StaffListItem({
    super.key,
    required this.name,
    required this.department,
    this.imageUrl,
    this.isFavorite = false,
    required this.onFavoriteTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryWithOpacity20,
                width: 2,
              ),
              color: AppColors.primaryWithOpacity10,
            ),
            child: imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, e, s) => const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 28,
                  ),
          ),
          const SizedBox(width: 16),

          // Name & Department
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  department,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Favorite Button
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
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFavorite ? AppColors.primary : Colors.grey.shade400,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Contact Button
              GestureDetector(
                onTap: onContactTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryWithOpacity10,
                  ),
                  child: const Icon(
                    Icons.mail_outline,
                    size: 18,
                    color: AppColors.primary,
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
