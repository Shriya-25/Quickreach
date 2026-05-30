import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/pending_screen.dart';
import '../features/auth/screens/rejected_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/reports/screens/reports_screen.dart';
import '../features/reports/screens/create_report_screen.dart';
import '../features/staff/screens/staff_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/sos/screens/sos_screen.dart';
import '../features/admin/screens/admin_dashboard_screen.dart';
import '../core/widgets/main_shell.dart';
import '../core/services/firestore_service.dart';
import '../core/constants/app_constants.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  static final _firestoreService = FirestoreService();

  // ── Public routes (no auth required) ──────────────────────────────────────
  static const _publicRoutes = ['/splash', '/login', '/signup'];

  // ── Redirect guard ─────────────────────────────────────────────────────────
  static Future<String?> _redirect(
      BuildContext context, GoRouterState state) async {
    final location = state.uri.path;
    final user = FirebaseAuth.instance.currentUser;

    // Not logged in → send to login (unless already on a public route)
    if (user == null) {
      if (_publicRoutes.contains(location)) return null;
      return '/login';
    }

    // Already on splash — let splash handle its own routing
    if (location == '/splash') return null;

    // On public auth routes while logged in → resolve destination
    if (location == '/login' || location == '/signup') {
      return await _resolveDestination(user.uid);
    }

    // On pending/rejected — verify they still belong there
    if (location == '/pending' || location == '/rejected') {
      return null; // let the screen handle sign-out
    }

    // On admin routes — verify admin
    if (location.startsWith('/admin')) {
      final isAdmin = await _firestoreService.isAdmin(user.uid);
      if (!isAdmin) return '/home';
      return null;
    }

    // On user routes — verify approved
    final userModel = await _firestoreService.getUserById(user.uid);
    if (userModel == null) return '/login';

    switch (userModel.approvalStatus) {
      case AppConstants.approvalPending:
        if (location == '/pending') return null;
        return '/pending';
      case AppConstants.approvalRejected:
        if (location == '/rejected') return null;
        return '/rejected';
      default:
        return null; // approved — allow
    }
  }

  static Future<String> _resolveDestination(String uid) async {
    final isAdmin = await _firestoreService.isAdmin(uid);
    if (isAdmin) return '/admin';

    final userModel = await _firestoreService.getUserById(uid);
    if (userModel == null) return '/login';

    switch (userModel.approvalStatus) {
      case AppConstants.approvalApproved:
        return '/home';
      case AppConstants.approvalRejected:
        return '/rejected';
      default:
        return '/pending';
    }
  }

  // ── Router ─────────────────────────────────────────────────────────────────
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: _redirect,
    routes: [
      // ── Splash ─────────────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ── Auth ───────────────────────────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/pending',
        builder: (context, state) => const PendingScreen(),
      ),
      GoRoute(
        path: '/rejected',
        builder: (context, state) => const RejectedScreen(),
      ),

      // ── SOS (full-screen overlay) ──────────────────────────────────────────
      GoRoute(
        path: '/sos',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SosScreen(),
      ),

      // ── Admin ──────────────────────────────────────────────────────────────
      GoRoute(
        path: '/admin',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminDashboardScreen(),
      ),

      // ── User shell with bottom nav ─────────────────────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/staff',
            builder: (context, state) => const StaffScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // ── Create Report (full-screen) ────────────────────────────────────────
      GoRoute(
        path: '/reports/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateReportScreen(),
      ),
    ],
  );
}
