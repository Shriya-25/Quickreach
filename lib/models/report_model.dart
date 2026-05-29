class ReportModel {
  final String reportId;
  final String userId;
  final String userName;
  final String type;
  final String location;
  final String description;
  final String? imageUrl;
  final String visibility; // 'public' or 'private'
  final String status; // 'pending', 'in_progress', 'resolved', 'rejected'
  final String? assignedTo;
  final String? adminComment;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReportModel({
    required this.reportId,
    required this.userId,
    required this.userName,
    required this.type,
    required this.location,
    required this.description,
    this.imageUrl,
    required this.visibility,
    required this.status,
    this.assignedTo,
    this.adminComment,
    required this.createdAt,
    this.updatedAt,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      reportId: map['reportId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      type: map['type'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      visibility: map['visibility'] ?? 'private',
      status: map['status'] ?? 'pending',
      assignedTo: map['assignedTo'],
      adminComment: map['adminComment'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'userId': userId,
      'userName': userName,
      'type': type,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'visibility': visibility,
      'status': status,
      'assignedTo': assignedTo,
      'adminComment': adminComment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ReportModel copyWith({
    String? reportId,
    String? userId,
    String? userName,
    String? type,
    String? location,
    String? description,
    String? imageUrl,
    String? visibility,
    String? status,
    String? assignedTo,
    String? adminComment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReportModel(
      reportId: reportId ?? this.reportId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      type: type ?? this.type,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      visibility: visibility ?? this.visibility,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      adminComment: adminComment ?? this.adminComment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
