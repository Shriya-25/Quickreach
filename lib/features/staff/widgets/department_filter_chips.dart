import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FilterChipData {
  final String label; // empty string = icon chip
  final String value;
  const FilterChipData({required this.label, required this.value});
}

class DepartmentFilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  static const List<FilterChipData> chips = [
    FilterChipData(label: '', value: 'FAV'),       // ★ icon chip
    FilterChipData(label: 'All', value: 'All'),
    FilterChipData(label: 'CS', value: 'Computer Science'),
    FilterChipData(label: 'IT', value: 'Information Technology'),
    FilterChipData(label: 'ENTC', value: 'ENTC'),
    FilterChipData(label: 'INST', value: 'Instrumentation'),
    FilterChipData(label: 'EE', value: 'Electrical'),
  ];

  const DepartmentFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final chip = chips[index];
          final isSelected = chip.value == selectedFilter;
          final isFavChip = chip.value == 'FAV';

          return Padding(
            padding: const EdgeInsets.only(right: 7),
            child: GestureDetector(
              onTap: () => onSelected(chip.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: EdgeInsets.symmetric(
                  horizontal: isFavChip ? 10 : 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFDDE1E7),
                  ),
                ),
                child: isFavChip
                    ? Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : AppColors.primary,
                      )
                    : Text(
                        chip.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
