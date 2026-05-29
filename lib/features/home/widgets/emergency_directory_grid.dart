import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EmergencyContact {
  final String name;
  final String subtitle;
  final IconData icon;
  final bool isPrimary;

  const EmergencyContact({
    required this.name,
    required this.subtitle,
    required this.icon,
    this.isPrimary = false,
  });
}

class EmergencyDirectoryGrid extends StatefulWidget {
  const EmergencyDirectoryGrid({super.key});

  @override
  State<EmergencyDirectoryGrid> createState() => _EmergencyDirectoryGridState();
}

class _EmergencyDirectoryGridState extends State<EmergencyDirectoryGrid> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<EmergencyContact> _contacts = const [
    EmergencyContact(
      name: 'Campus Police',
      subtitle: 'Ext. 911',
      icon: Icons.local_police,
      isPrimary: true,
    ),
    EmergencyContact(
      name: 'Student Health',
      subtitle: '08:00 - 18:00',
      icon: Icons.medical_services,
    ),
    EmergencyContact(
      name: 'Counseling',
      subtitle: '24/7 Support',
      icon: Icons.psychology,
    ),
    EmergencyContact(
      name: 'Facilities',
      subtitle: 'Maintenance',
      icon: Icons.construction,
    ),
    EmergencyContact(
      name: 'Fire Department',
      subtitle: 'Ext. 101',
      icon: Icons.local_fire_department,
    ),
    EmergencyContact(
      name: 'Security',
      subtitle: 'Ext. 200',
      icon: Icons.security,
    ),
    EmergencyContact(
      name: 'Ambulance / EMS',
      subtitle: 'Ext. 102',
      icon: Icons.local_hospital,
    ),
    EmergencyContact(
      name: 'Anti-Ragging Cell',
      subtitle: '24/7 Helpline',
      icon: Icons.person_off,
    ),
    EmergencyContact(
      name: 'Staff Directory',
      subtitle: 'Faculty Info',
      icon: Icons.contact_page,
    ),
  ];

  List<EmergencyContact> get _filteredContacts {
    if (_searchQuery.isEmpty) return _contacts;
    return _contacts
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Emergency Directory',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Search contacts (e.g., Police, Fire)...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: _filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = _filteredContacts[index];
              return _buildContactCard(contact);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(EmergencyContact contact) {
    return GestureDetector(
      onTap: () {
        // TODO: Handle call/action
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: contact.isPrimary
                    ? AppColors.primaryWithOpacity10
                    : const Color(0xFFF1F5F9),
              ),
              child: Icon(
                contact.icon,
                color: contact.isPrimary
                    ? AppColors.primary
                    : const Color(0xFF475569),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            // Name
            Text(
              contact.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Subtitle
            Text(
              contact.subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
