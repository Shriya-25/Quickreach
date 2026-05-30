import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/utils/seed_staff.dart';
import '../../../models/staff_model.dart';
import '../widgets/staff_list_item.dart';
import '../widgets/department_filter_chips.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final _searchController = TextEditingController();
  final _firestoreService = FirestoreService();

  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isSeeding = false;

  // Fixed filter order as specified
  static const List<String> _filters = [
    'All',
    'Computer Science',
    'Information Technology',
    'ENTC',
    'Instrumentation',
    'Electrical',
    'Staff',
  ];

  List<StaffModel> _applyFilters(List<StaffModel> all) {
    var list = all.toList();

    // Department / role filter
    if (_selectedFilter != 'All') {
      if (_selectedFilter == 'Staff') {
        // Show Staff + Security + Principal roles
        list = list
            .where((s) =>
                s.role == 'Staff' ||
                s.role == 'Security' ||
                s.role == 'Principal')
            .toList();
      } else {
        list = list.where((s) => s.department == _selectedFilter).toList();
      }
    }

    // Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((s) =>
              s.name.toLowerCase().contains(q) ||
              s.department.toLowerCase().contains(q) ||
              s.role.toLowerCase().contains(q))
          .toList();
    }

    // Sort: Principal → HOD → Faculty → Staff → Security
    const order = ['Principal', 'HOD', 'Faculty', 'Staff', 'Security'];
    list.sort((a, b) {
      final ai = order.indexOf(a.role);
      final bi = order.indexOf(b.role);
      if (ai != bi) return ai.compareTo(bi);
      return a.name.compareTo(b.name);
    });

    return list;
  }

  Future<void> _seedData() async {
    setState(() => _isSeeding = true);
    try {
      await seedStaff();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff data seeded successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seed failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSeeding = false);
    }
  }

  Future<void> _callStaff(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _emailStaff(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
          // ── Header ───────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
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
                        // Seed button — tap to populate Firestore
                        if (_isSeeding)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.primary),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.cloud_upload_outlined,
                                color: AppColors.textHint),
                            tooltip: 'Seed staff data',
                            onPressed: _seedData,
                          ),
                      ],
                    ),
                  ),

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Search by name, department or role',
                          hintStyle: const TextStyle(
                              fontSize: 13, color: AppColors.textHint),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppColors.textHint, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      size: 18, color: AppColors.textHint),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),

                  // Filter chips
                  DepartmentFilterChips(
                    departments: _filters,
                    selectedDepartment: _selectedFilter,
                    onSelected: (f) => setState(() => _selectedFilter = f),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── Staff List ───────────────────────────────────────────────────
          Expanded(
            child: StreamBuilder<List<StaffModel>>(
              stream: _firestoreService.getStaff(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: AppColors.error)),
                  );
                }

                final all = snapshot.data ?? [];

                if (all.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_outline_rounded,
                            size: 56, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        const Text(
                          'No staff data yet.',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap the upload icon above to seed data.',
                          style: TextStyle(
                              color: AppColors.textHint, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                final filtered = _applyFilters(all);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 48, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text(
                          'No results for "$_searchQuery"',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final staff = filtered[index];
                    // Show email only for Faculty, HOD, Principal
                    final showEmail = ['Faculty', 'HOD', 'Principal']
                        .contains(staff.role);
                    return StaffListItem(
                      staff: staff,
                      onCallTap: () => _callStaff(staff.phone),
                      onEmailTap: (showEmail && staff.email != null)
                          ? () => _emailStaff(staff.email!)
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
