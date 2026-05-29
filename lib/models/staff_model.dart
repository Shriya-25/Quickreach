class StaffModel {
  final String staffId;
  final String name;
  final String department;
  final String role;
  final String phone;
  final String? email;
  final String? imageUrl;
  final String orgCode;
  final bool isAvailable;

  StaffModel({
    required this.staffId,
    required this.name,
    required this.department,
    required this.role,
    required this.phone,
    this.email,
    this.imageUrl,
    required this.orgCode,
    this.isAvailable = true,
  });

  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      staffId: map['staffId'] ?? '',
      name: map['name'] ?? '',
      department: map['department'] ?? '',
      role: map['role'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      imageUrl: map['imageUrl'],
      orgCode: map['orgCode'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
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
      'orgCode': orgCode,
      'isAvailable': isAvailable,
    };
  }

  StaffModel copyWith({
    String? staffId,
    String? name,
    String? department,
    String? role,
    String? phone,
    String? email,
    String? imageUrl,
    String? orgCode,
    bool? isAvailable,
  }) {
    return StaffModel(
      staffId: staffId ?? this.staffId,
      name: name ?? this.name,
      department: department ?? this.department,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      orgCode: orgCode ?? this.orgCode,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
