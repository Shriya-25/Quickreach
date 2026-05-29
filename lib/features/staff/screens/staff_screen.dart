import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/staff_list_item.dart';
import '../widgets/department_filter_chips.dart';

class StaffMember {
  final String name;
  final String department;
  final String? imageUrl;
  final bool isFavorite;

  const StaffMember({
    required this.name,
    required this.department,
    this.imageUrl,
    this.isFavorite = false,
  });
}

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedDepartment = 'All';

  // TODO: Replace with real data from Firestore
  final List<StaffMember> _staffMembers = const [
    StaffMember(
      name: 'Dr. Alice Smith',
      department: 'Computer Science',
      isFavorite: true,
    ),
    StaffMember(
      name: 'Robert Johnson',
      department: 'Student Affairs',
    ),
    StaffMember(
      name: 'Prof. Elena Rodriguez',
      department: 'Economics',
    ),
    StaffMember(
      name: 'Marcus Chen',
      department: 'IT Services',
    ),
    StaffMember(
      name: 'Sarah Jenkins',
      department: 'Library Services',
    ),
  ];

  List<String> get _departments {
    final deps = _staffMembers.map((s) => s.department).toSet().toList();
    return ['All', ...deps];
  }

  List<StaffMember> get _filteredStaff {
    var filtered = _staffMembers.toList();

    if (_selectedDepartment != 'All') {
      filtered = filtered.where((s) => s.department == _selectedDepartment).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.department.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundLight.withValues(alpha: 0.8),
              border: Border(
                bottom: BorderSide(color: AppColors.primaryWithOpacity10),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Staff Directory',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by name or department',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Department Filter Chips
                  DepartmentFilterChips(
                    departments: _departments,
                    selectedDepartment: _selectedDepartment,
                    onSelected: (dept) {
                      setState(() => _selectedDepartment = dept);
                    },
                  ),

                  const SizedBox(height: 8),

                  // Staff List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _filteredStaff.map((staff) {
                        return StaffListItem(
                          name: staff.name,
                          department: staff.department,
                          isFavorite: staff.isFavorite,
                          onFavoriteTap: () {
                            // TODO: Toggle favorite
                          },
                          onContactTap: () {
                            // TODO: Call or email
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
