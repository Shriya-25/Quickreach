class AlertModel {
  final String alertId;
  final String title;
  final String description;
  final String priority; // 'critical', 'important', 'general'
  final String orgCode;
  final String createdBy;
  final DateTime timestamp;
  final bool isActive;

  AlertModel({
    required this.alertId,
    required this.title,
    required this.description,
    required this.priority,
    required this.orgCode,
    required this.createdBy,
    required this.timestamp,
    this.isActive = true,
  });

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      alertId: map['alertId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? 'general',
      orgCode: map['orgCode'] ?? '',
      createdBy: map['createdBy'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alertId': alertId,
      'title': title,
      'description': description,
      'priority': priority,
      'orgCode': orgCode,
      'createdBy': createdBy,
      'timestamp': timestamp.toIso8601String(),
      'isActive': isActive,
    };
  }

  AlertModel copyWith({
    String? alertId,
    String? title,
    String? description,
    String? priority,
    String? orgCode,
    String? createdBy,
    DateTime? timestamp,
    bool? isActive,
  }) {
    return AlertModel(
      alertId: alertId ?? this.alertId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      orgCode: orgCode ?? this.orgCode,
      createdBy: createdBy ?? this.createdBy,
      timestamp: timestamp ?? this.timestamp,
      isActive: isActive ?? this.isActive,
    );
  }
}
