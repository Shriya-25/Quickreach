class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String idNumber;
  final String orgCode;
  final String role;
  final String? profilePicUrl;
  final List<EmergencyContact> emergencyContacts;
  final MedicalInfo? medicalInfo;
  final bool isApproved;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.idNumber,
    required this.orgCode,
    required this.role,
    this.profilePicUrl,
    this.emergencyContacts = const [],
    this.medicalInfo,
    this.isApproved = false,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      idNumber: map['idNumber'] ?? '',
      orgCode: map['orgCode'] ?? '',
      role: map['role'] ?? 'user',
      profilePicUrl: map['profilePicUrl'],
      emergencyContacts: (map['emergencyContacts'] as List<dynamic>?)
              ?.map((e) => EmergencyContact.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      medicalInfo: map['medicalInfo'] != null
          ? MedicalInfo.fromMap(map['medicalInfo'] as Map<String, dynamic>)
          : null,
      isApproved: map['isApproved'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'idNumber': idNumber,
      'orgCode': orgCode,
      'role': role,
      'profilePicUrl': profilePicUrl,
      'emergencyContacts': emergencyContacts.map((e) => e.toMap()).toList(),
      'medicalInfo': medicalInfo?.toMap(),
      'isApproved': isApproved,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? idNumber,
    String? orgCode,
    String? role,
    String? profilePicUrl,
    List<EmergencyContact>? emergencyContacts,
    MedicalInfo? medicalInfo,
    bool? isApproved,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      idNumber: idNumber ?? this.idNumber,
      orgCode: orgCode ?? this.orgCode,
      role: role ?? this.role,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relationship;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relationship,
  });

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      relationship: map['relationship'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'relationship': relationship,
    };
  }
}

class MedicalInfo {
  final String? conditions;
  final String? allergies;
  final String? bloodGroup;

  MedicalInfo({
    this.conditions,
    this.allergies,
    this.bloodGroup,
  });

  factory MedicalInfo.fromMap(Map<String, dynamic> map) {
    return MedicalInfo(
      conditions: map['conditions'],
      allergies: map['allergies'],
      bloodGroup: map['bloodGroup'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conditions': conditions,
      'allergies': allergies,
      'bloodGroup': bloodGroup,
    };
  }
}
