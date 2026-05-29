import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AlertItem {
  final String title;
  final String description;
  final String timeAgo;
  final Color color;
  final IconData icon;

  const AlertItem({
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.color,
    required this.icon,
  });
}

class LiveAlertsTicker extends StatefulWidget {
  const LiveAlertsTicker({super.key});

  @override
  State<LiveAlertsTicker> createState() => _LiveAlertsTickerState();
}

class _LiveAlertsTickerState extends State<LiveAlertsTicker> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // TODO: Replace with real data from Firestore
  final List<AlertItem> _alerts = const [
    AlertItem(
      title: 'Active: Fire Alarm',
      description: 'Science Bldg, Wing B. Evacuate immediately...',
      timeAgo: '2m ago',
      color: AppColors.primary,
      icon: Icons.warning,
    ),
    AlertItem(
      title: 'Update: Power Outage',
      description: 'Restoration in progress for North Campus...',
      timeAgo: '15m ago',
      color: Color(0xFFF59E0B),
      icon: Icons.update,
    ),
    AlertItem(
      title: 'Notice: Road Closure',
      description: 'Main Gate closed for maintenance. Use West...',
      timeAgo: '1h ago',
      color: Color(0xFF3B82F6),
      icon: Icons.info,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_alerts.isEmpty) return;
      setState(() {
        _currentPage = (_currentPage + 1) % _alerts.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_alerts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Alerts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${_alerts.length} Active',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Alert Ticker
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _alerts.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  return _buildAlertItem(alert);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(AlertItem alert) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: alert.color, width: 4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: alert.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              alert.icon,
              size: 18,
              color: alert.color,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      alert.timeAgo,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
