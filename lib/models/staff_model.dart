class StaffModel {
  final String staffId;
  final String name;
  final String department;
  final String role; // Principal | HOD | Faculty | Staff | Security
  final String phone;
  final String? email;
  final String? imageUrl;

  StaffModel({
    required this.staffId,
    required this.name,
    required this.department,
    required this.role,
    required this.phone,
    this.email,
    this.imageUrl,
  });

  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      staffId: map['staffId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      department: map['department'] as String? ?? '',
      role: map['role'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'staffId': staffId,
      'name': name,
      'department': department,
      'role': role,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}
