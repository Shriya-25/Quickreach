import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';
import '../../models/admin_model.dart';
import '../../models/report_model.dart';
import '../../models/staff_model.dart';
import '../../models/alert_model.dart';
import '../constants/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== ADMIN DETECTION ====================

  /// Returns true if the given UID exists in the admins collection.
  Future<bool> isAdmin(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.adminsCollection)
          .doc(uid)
          .get();
      debugPrint('isAdmin check — collection: ${AppConstants.adminsCollection}, uid: $uid, exists: ${doc.exists}');
      return doc.exists;
    } catch (e) {
      debugPrint('isAdmin error: $e');
      return false;
    }
  }

  /// Fetches the AdminModel for a given UID, or null if not an admin.
  Future<AdminModel?> getAdmin(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.adminsCollection)
          .doc(uid)
          .get();
      if (!doc.exists || doc.data() == null) return null;
      return AdminModel.fromMap(doc.data()!);
    } catch (_) {
      return null;
    }
  }

  // ==================== USER APPROVAL ====================

  /// Stream of all users with approvalStatus == "pending", ordered by createdAt.
  Stream<List<UserModel>> getPendingUsers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .where('approvalStatus', isEqualTo: AppConstants.approvalPending)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap(d.data()))
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)));
  }

  /// Stream of all users with approvalStatus == "approved".
  Stream<List<UserModel>> getApprovedUsers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .where('approvalStatus', isEqualTo: AppConstants.approvalApproved)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap(d.data()))
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)));
  }

  /// Updates the approvalStatus field of a user document.
  Future<void> updateApprovalStatus(String uid, String status) async {
    if (status != AppConstants.approvalPending &&
        status != AppConstants.approvalApproved &&
        status != AppConstants.approvalRejected) {
      throw ArgumentError(
          'Invalid approval status: $status. Must be pending, approved, or rejected.');
    }
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update({'approvalStatus': status});
  }

  /// Fetches a single user document by UID.
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!);
  }

  // ==================== REPORTS ====================

  Future<void> submitReport(ReportModel report) async {
    await _firestore
        .collection(AppConstants.reportsCollection)
        .doc(report.reportId)
        .set(report.toMap());
  }

  Stream<List<ReportModel>> getPublicReports() {
    return _firestore
        .collection(AppConstants.reportsCollection)
        .where('visibility', isEqualTo: AppConstants.visibilityPublic)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ReportModel.fromMap(d.data()))
            .where((r) => r.status != AppConstants.statusRejected)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  Stream<List<ReportModel>> getUserReports(String userId) {
    return _firestore
        .collection(AppConstants.reportsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ReportModel.fromMap(d.data()))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  // ==================== STAFF ====================

  Stream<List<StaffModel>> getStaff() {
    return _firestore
        .collection(AppConstants.staffCollection)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => StaffModel.fromMap(d.data())).toList());
  }

  // ==================== ALERTS ====================

  Stream<List<AlertModel>> getActiveAlerts() {
    return _firestore
        .collection(AppConstants.alertsCollection)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => AlertModel.fromMap(d.data()))
            .toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp)));
  }

  // ==================== SOS ====================

  Future<void> sendSosAlert({
    required String userId,
    required String userName,
  }) async {
    await _firestore.collection(AppConstants.sosRequestsCollection).add({
      'userId': userId,
      'userName': userName,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
