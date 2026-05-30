class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String collegeId;
  final String role; // 'Student' | 'Faculty' | 'Staff'
  final String approvalStatus; // 'pending' | 'approved' | 'rejected'
  final String? profilePhoto;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.collegeId,
    required this.role,
    this.approvalStatus = 'pending',
    this.profilePhoto,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      collegeId: map['collegeId'] as String? ?? '',
      role: map['role'] as String? ?? 'Student',
      approvalStatus: map['approvalStatus'] as String? ?? 'pending',
      profilePhoto: map['profilePhoto'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'collegeId': collegeId,
      'role': role,
      'approvalStatus': approvalStatus,
      'profilePhoto': profilePhoto,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? collegeId,
    String? role,
    String? approvalStatus,
    String? profilePhoto,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      collegeId: collegeId ?? this.collegeId,
      role: role ?? this.role,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isApproved => approvalStatus == 'approved';
  bool get isPending => approvalStatus == 'pending';
  bool get isRejected => approvalStatus == 'rejected';
}
