class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'QuickReach';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Campus Safety at Your Fingertips';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String adminsCollection = 'admins';
  static const String reportsCollection = 'reports';
  static const String staffCollection = 'staff';
  static const String alertsCollection = 'alerts';
  static const String organizationsCollection = 'organizations';
  static const String sosAlertsCollection = 'sos_alerts';
  static const String sosRequestsCollection = 'sos_requests';

  // ImageBB
  static const String imageBBBaseUrl = 'https://api.imgbb.com/1/upload';
  // TODO: Replace with your actual ImageBB API key
  static const String imageBBApiKey = 'YOUR_IMAGEBB_API_KEY';

  // Report Limits
  static const int maxReportsPerDay = 5;
  static const int maxEmergencyContacts = 2;

  // SOS
  static const int sosCountdownSeconds = 3;
  static const int sosAlarmDurationSeconds = 30;

  // Alert Priorities
  static const String priorityCritical = 'critical';
  static const String priorityImportant = 'important';
  static const String priorityGeneral = 'general';

  // Report Status
  static const String statusPending = 'pending';
  static const String statusInProgress = 'in_progress';
  static const String statusResolved = 'resolved';
  static const String statusRejected = 'rejected';

  // Report Visibility
  static const String visibilityPublic = 'public';
  static const String visibilityPrivate = 'private';

  // Approval Status
  static const String approvalPending = 'pending';
  static const String approvalApproved = 'approved';
  static const String approvalRejected = 'rejected';

  // User Roles
  static const String roleStudent = 'Student';
  static const String roleFaculty = 'Faculty';
  static const String roleStaff = 'Staff';
  static const String roleAdmin = 'admin';

  // Legacy role constants (kept for compatibility)
  static const String roleSuperAdmin = 'super_admin';
  static const String roleOrgAdmin = 'org_admin';
  static const String roleSubAdmin = 'sub_admin';
  static const String roleUser = 'user';
}
