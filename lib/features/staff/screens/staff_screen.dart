import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/firestore_service.dart';
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

  // Local favourites — stored in memory (can be persisted later)
  final Set<String> _favourites = {};

  void _toggleFavourite(String staffId) {
    setState(() {
      if (_favourites.contains(staffId)) {
        _favourites.remove(staffId);
      } else {
        _favourites.add(staffId);
      }
    });
  }

  List<StaffModel> _applyFilters(List<StaffModel> all) {
    var list = all.toList();

    // FAV filter
    if (_selectedFilter == 'FAV') {
      list = list.where((s) => _favourites.contains(s.staffId)).toList();
    } else if (_selectedFilter != 'All') {
      list = list.where((s) => s.department == _selectedFilter).toList();
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

    // Sort: favourites first, then Principal → HOD → Faculty → Staff → Security
    const roleOrder = ['Principal', 'HOD', 'Faculty', 'Staff', 'Security'];
    list.sort((a, b) {
      final aFav = _favourites.contains(a.staffId) ? 0 : 1;
      final bFav = _favourites.contains(b.staffId) ? 0 : 1;
      if (aFav != bFav) return aFav.compareTo(bFav);
      final ai = roleOrder.indexOf(a.role);
      final bi = roleOrder.indexOf(b.role);
      if (ai != bi) return ai.compareTo(bi);
      return a.name.compareTo(b.name);
    });

    return list;
  }

  Future<void> _callStaff(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
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

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFDDE1E7)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search name, department or role...',
                          hintStyle: const TextStyle(
                              fontSize: 13, color: AppColors.textHint),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppColors.textHint, size: 18),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      size: 16, color: AppColors.textHint),
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
                    selectedFilter: _selectedFilter,
                    onSelected: (f) => setState(() => _selectedFilter = f),
                  ),
                  const SizedBox(height: 10),
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
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 13)),
                  );
                }

                final all = snapshot.data ?? [];

                if (all.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline_rounded,
                            size: 52, color: AppColors.textHint),
                        SizedBox(height: 12),
                        Text(
                          'No staff data available.',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 14),
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
                          _selectedFilter == 'FAV'
                              ? 'No favourites yet.\nTap ⭐ on any staff card.'
                              : 'No results found.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: filtered
                      .map((s) => StaffListItem(
                            staff: s,
                            isFavorite: _favourites.contains(s.staffId),
                            onFavoriteTap: () => _toggleFavourite(s.staffId),
                            onCallTap: () => _callStaff(s.phone),
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
