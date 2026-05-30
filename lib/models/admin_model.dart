class AdminModel {
  final String uid;
  final String name;
  final String role;

  AdminModel({
    required this.uid,
    required this.name,
    this.role = 'admin',
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: map['role'] as String? ?? 'admin',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'role': role,
    };
  }
}
