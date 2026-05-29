import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/report_model.dart';
import '../../models/staff_model.dart';
import '../../models/alert_model.dart';
import '../constants/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== REPORTS ====================

  // Submit a report
  Future<void> submitReport(ReportModel report) async {
    await _firestore
        .collection(AppConstants.reportsCollection)
        .doc(report.reportId)
        .set(report.toMap());
  }

  // Get reports for an organization
  Stream<List<ReportModel>> getReports(String orgCode) {
    return _firestore
        .collection(AppConstants.reportsCollection)
        .where('visibility', isEqualTo: AppConstants.visibilityPublic)
        .where('status', isNotEqualTo: AppConstants.statusRejected)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReportModel.fromMap(doc.data()))
            .toList());
  }

  // Get user's reports
  Stream<List<ReportModel>> getUserReports(String userId) {
    return _firestore
        .collection(AppConstants.reportsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReportModel.fromMap(doc.data()))
            .toList());
  }

  // ==================== STAFF ====================

  // Get staff for an organization
  Stream<List<StaffModel>> getStaff(String orgCode) {
    return _firestore
        .collection(AppConstants.staffCollection)
        .where('orgCode', isEqualTo: orgCode)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StaffModel.fromMap(doc.data()))
            .toList());
  }

  // ==================== ALERTS ====================

  // Get active alerts for an organization
  Stream<List<AlertModel>> getAlerts(String orgCode) {
    return _firestore
        .collection(AppConstants.alertsCollection)
        .where('orgCode', isEqualTo: orgCode)
        .where('isActive', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AlertModel.fromMap(doc.data()))
            .toList());
  }

  // ==================== SOS ====================

  // Send SOS alert
  Future<void> sendSosAlert({
    required String userId,
    required String userName,
    required String orgCode,
    double? latitude,
    double? longitude,
  }) async {
    await _firestore.collection(AppConstants.sosAlertsCollection).add({
      'userId': userId,
      'userName': userName,
      'orgCode': orgCode,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
      'isActive': true,
    });
  }
}
